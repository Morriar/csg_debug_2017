#!/bin/bash

set -e

# To generate the final tests files
mkdir -p tests

# To generate the temporary crap
mkdir -p out

i=1

# for each data (in data) we plan 10 variations (rnd).
for rnd in `seq 10`; do
	for txt in data/*.txt; do
		# Get the data
		dat="data/`basename "$txt" .txt`"
		out="out/test$i"

		if test "$rnd" != 1; then
			# Because I'm lazy, I do not plan to collect other lyrics. So just shuffle the paragraphs for other tests!
			txt0="$out.txt"
			perl -e 'use List::Util 'shuffle'; $/ = ""; @l=(<>); @l=shuffle(@l); print join "", @l;' "$txt" > "$txt0"
			txt=$txt0
		fi

		# The key file. Important so we do not generate again and again. Remove it to regenerate a key.
		# Do not move it to the PUBLIC
		key="tests/test$i.key"

		# The algo is fragile. Here we just generate random keys until one is OK
		for try in `seq 100`; do
			# Is the previous loop an error. then kill the buggy key
			if test "$try" != 1; then
				echo -e "\e[31mERROR\e[0m $i $dat. retry with another key"
				rm $key
			fi

			echo "== test $i: file $dat ($try) =="
			# Get (or create) the key
			if ! test -e "$key"; then
				((klen = RANDOM % 30 + 10))
				head -c $klen /dev/urandom > "$key"
			fi
			echo -n "KEY(`stat -c%s "$key"`)="
			xxd -p "$key" | cat

			# Encode the bin
			bin="$out.bin"
			bin/ouija "$txt" "$key" > "$bin"

			# Check the breakability
			bin/ouija "$bin" > "$out.txt2"
			diff -u "$txt" "$out.txt2" || continue

			# Create the input by merging the data and the bin
			in="tests/test$i.in"
			if (( rnd % 2 == 0 )); then
				# put the data in the comment tag (near the begin of the file)
				exiftool "-all=" "-comment<=$bin" "$dat" -o - > "$in"
			else
				# just put the data at the end of the file. jpeg seems ok with it.
				exiftool "-all=" "$dat" -o - > "$in"
				cat "$bin" >> "$in"
			fi

			# Create the output
			res="tests/test$i.res"
			bin/ouija "$in" > "$out.txt3"
			strings -e S "$out.txt3" > "$res"

			# Check the final result
			diff -u <(strings -n 20 "$txt" | tail -n +2) <(strings -n 20  "$out.txt3" | tail -n +2) || continue

			# Leave the try-loop happy.
			echo -e "\e[32mSUCCESS\e[0m $i $dat"
			break
		done
		((i++))
	done
done

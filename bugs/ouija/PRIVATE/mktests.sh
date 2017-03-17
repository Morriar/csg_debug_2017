#!/bin/bash

set -e

mkdir -p tests

i=1
for txt in data/*.txt; do
	# Get the data
	dat="data/`basename "$txt" .txt`"

	echo "== test $i: file $dat =="
	# Get (or create) the key
	key="$dat.key"
	if ! test -e "$key"; then
		((klen = RANDOM % 30 + 10))
		head -c $klen /dev/urandom > "$key"
	fi
	echo -n "KEY(`stat -c%s "$key"`)="
	xxd -p "$key" | cat

	# Encode the bin
	bin="$dat.bin"
	bin/ouija "$txt" "$key" > "$bin"

	# Check the breakability
	bin/ouija "$bin" > "$txt"2
	diff -u "$txt" "$txt"2

	# Create the input by merging the data and the bin
	in="tests/test$i.in"
	exiftool "-all=" "-comment<=$bin" "$dat" -o - > "$in"

	# Create the output
	res="tests/test$i.res"
	bin/ouija "$in" > "$txt"3
	strings -e S "$txt"3 > "$res"
	diff -u <(strings -n 20 "$txt" | tail -n +2) <(strings -n 20  "$txt"3 | tail -n +2)
	((i++))
done

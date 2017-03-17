#!/bin/bash

set -e
set -x

mkdir -p tests
RANDOM=0

i=1
for txt in data/*.txt; do
	# Get the data
	dat="data/`basename "$txt" .txt`"

	# Get (or create) the key
	key="$dat.key"
	if ! test -e "$key"; then
		((klen = RANDOM % 30 + 10))
		head -c $klen /dev/urandom > "$key"
	fi
	echo -n "KEY(`stat -c%s "$key"`)="
	xxd -p "$key"

	# Encode the bin
	bin="$dat.bin"
	./a.out "$txt" "$key" > "$bin"

	# Check the breakability
	./a.out "$bin" > "$txt"2
	diff -u "$txt" "$txt"2

	# Create the input by merging the data and the bin
	in="tests/test$i.in"
	exiftool "-comment<=$bin" "$dat" -o - > "$in"

	# Create the output
	res="tests/test$i.res"
	./a.out "$in" | strings > "$res"
	((i++))
done

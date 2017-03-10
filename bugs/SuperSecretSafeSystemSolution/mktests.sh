#!/bin/bash

# Program to generate and check tests.

set -e

RANDOM=0
# Generate tests
for a in 0 1 2 3 4 5 6 7 8 9; do
	for b in '' 1 3 5 8 $RANDOM$RANDOM$RANDOM; do
	#for b in $RANDOM$RANDOM$RANDOM; do
		x=$a$b
		for i in cat.txt nyan.png; do
			echo "$i $x"
			rm $i.$x.out $i.out2 2>/dev/null || true
			bash sssss.good.sh $i $i.$x.out $x
			diff $i.$x.out $i.$x.out.sav
			bash sssss.dec.sh $i.$x.out $i.out2 $x
			diff $i $i.out2 && echo "OK!"
		done
	done
done


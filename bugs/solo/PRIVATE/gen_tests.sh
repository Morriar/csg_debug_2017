#!/bin/bash

options=("-p" "-b" "-r")

test_cpt=0
for option in ${options[*]}
do
	echo "Generating tests for $option..."
	for input in inputs/*; do
		printf -v bn "test%02d" $test_cpt
		echo "    $bn..."

		cat $input > tests/$bn.in
		echo -en $option > tests/$bn.in.args
		./run.sh $option tests/$bn.in > tests/$bn.res

		in_data=$(cat $input)
		out_data=$(cat tests/$bn.res)
		echo "input:"
		echo "$in_data"
		echo "output:"
		echo "$out_data"

		((test_cpt+=1))
	done
done

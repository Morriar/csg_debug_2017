#!/bin/bash

for i in `seq 10 50`
do
	if ! (($i % 2)); then
		city="Dome"
	else
		city="dome"
	fi
	python gen_tests.py $city $(($i * 6)) > tests/test_${i}.in
	python src/dispatch.py tests/test_${i}.in > tests/test_${i}.res

done

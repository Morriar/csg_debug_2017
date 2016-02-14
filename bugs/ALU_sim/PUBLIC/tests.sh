#!/bin/bash

run_test()
{
	run_input=$1
	run_output=$2
	./bin/aluemu "$run_input" > "$run_output" 2>&1
	return $?
}

diff_test()
{
	diff_input1=$1
	diff_input2=$2
	diff_output=$3
	diff -u -- "$diff_input1" "$diff_input2" > "$diff_output"
	return $?
}

run_all()
{
	rm out/*
	out_dir=$1
	tests_dir=$2

	echo -e "\nRun tests..."
	OK=0
	KO=0
	ALL=0

	for input in $(ls "$tests_dir"/*.cstm); do
		ALL=$(($ALL + 1))

		file=$(basename "$input")
		name="${file%.*}"

		out="$out_dir/$name.out"
		exp="$tests_dir/$name.res"

		run_test "$input" "$out"
		diff_test "$out" "$exp" "$out_dir/$name.diff"
		if [ "$?" == 0 ]; then
			echo " * [OK] $name"
			OK=$(($OK + 1))
		else
			echo " * [FAIL] $name (diff $out $exp)"
			KO=$(($KO + 1))
		fi
	done

	echo -e "\n [ALL: $ALL, KO: $KO, OK: $OK]\n"
	if [ $KO -gt 0 ]; then
		echo "Some tests have FAILED!"
		return 1
	else
		echo "All tests are OK!"
		return 0
	fi
}

mkdir -p out/
run_all "out" "tests"
exit $?

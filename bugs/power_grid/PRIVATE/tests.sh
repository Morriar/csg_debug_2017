#!/bin/bash

# Copyright 2016 Alexandre Terrasa <alexandre@moz-code.org>.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

compile()
{
	compile_log=$1
	make compile --no-print-directory > "$compile_log" 2>&1
	return $?
}

run_test()
{
	run_input=$1
	run_output=$2
	jail_home=$(dirname $run_output)
	make_jail $jail_home bin/z_status $run_input
	timeout -k 5 5 firejail --profile=jail.profile --quiet --private=$jail_home ./z_status "$run_input" 2>&1 | grep -v "Reading profile" > "$run_output"
	return $?
}

make_jail()
{
	jail_dir=$1
	jail_bin=$2
	jail_input=$3
	mkdir -p $jail_dir/tests
	cp $jail_bin $jail_dir
	cp $jail_input $jail_dir/tests/.
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
	out_dir=$1
	tests_dir=$2
	rm -rf $out_dir/*
	timestamp=$(date +"%s")

	echo "Compile bin..."
	compile "$out_dir/compile.$timestamp.log"
	if [ "$?" -ne 0 ]; then
		echo " * [FAIL] compile bin (cat $out_dir/compile.log)"
		exit 1
	fi

	echo -e "\nRun tests..."
	OK=0
	KO=0
	ALL=0

	for input in $(ls "$tests_dir"/*.in); do
		ALL=$(($ALL + 1))

		file=$(basename "$input")
		name="${file%.*}"

		out="$out_dir/$name.$timestamp.out"
		exp="$tests_dir/$name.res"

		run_test "$input" "$out"
		diff_test "$out" "$exp" "$out_dir/$name.$timestamp.diff"
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

run_one()
{
	name=$1
	out_dir=$2
	tests_dir=$3
	timestamp=$(date +"%s")

	echo "Compile bin..."
	compile "$out_dir/compile.$timestamp.log"
	if [ "$?" -ne 0 ]; then
		echo "[BUILD FAIL]"
		cat "$out_dir/compile.$timestamp.log"
		return 1
	fi

	input="$tests_dir/$name.in"
	out="$out_dir/$name.$timestamp.out"
	exp="$tests_dir/$name.res"

	echo "Run tests..."
	run_test "$input" "$out"
	diff_test "$out" "$exp" "$out_dir/$name.$timestamp.diff"
	if [ "$?" == 0 ]; then
		echo "[OK] $name"
		return 0
	else
		echo "[FAIL] $name"
		cat "$out_dir/$name.$timestamp.diff"
		return 1
	fi
}

mkdir -p out/
if [ -z "$1" ]; then
	run_all "out" "tests"
else
	run_one "$1" "out" "tests"
fi
exit $?

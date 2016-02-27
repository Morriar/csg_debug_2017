#!/bin/bash

# Copyright 2016 Jean Privat.
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

RANDOM=1
rm -rf tests

# 50 tests!
for t in `seq 50`; do

	dir="tests/data$t"
	mkdir -p $dir

	# Copy the user public data anyway!
	cp ../PUBLIC/data/* $dir

	# 3 a-files
	for i in `seq 3`; do
		file="$dir/a$RANDOM"
		for j in `seq 20`; do
			name=`shuf -n 1 names.txt | awk '{print($1);}'`
			idx=$((50 + RANDOM % 100))
			min=$((idx + RANDOM % 10 - RANDOM % 20))
			max=$((idx + RANDOM % 20 - RANDOM % 10))
			echo "$name $idx $min $max"
		done > "$file"
	done

	# 20 b-files
	for i in `seq 20`; do
		file="$dir/b_id$RANDOM"
		name=`shuf -n 1 names.txt | tr a-z A-Z`
		addr1=`shuf -n 1 names.txt | tr a-z A-Z`
		addr2=`shuf -n 1 address.txt`
		occ=`shuf -n 1 occupation.txt`
		printf "NAME $name\nADDRESS $addr1 $addr2\nOCCUPATION $occ\n" > "$file"
	done

	# 20 c-files
	for i in `seq 20`; do
		file="$dir/c_id$RANDOM"
		nb=$((5 + RANDOM % 10))
		for j in `seq $nb`; do
			if [ $((RANDOM % 3)) = 0 ]; then
				val=$((2 + RANDOM % 3))
				echo "DEMOTE $val"
			else
				val=$((1 + RANDOM % 10000))
				echo "PROMOTE $val"
			fi
		done > "$file"
	done

	# 2 d-files
	for i in `seq 2`; do
		file="$dir/d$RANDOM"
		nb=$((5 + RANDOM % 10))
		for j in `seq $nb`; do
			name=`shuf -n 1 names.txt`
			for k in `seq $j`; do echo $name; done
		done > tmp
		shuf tmp > "$file"
	done

	# Get the expected results
	./test.sh "$dir" > "$dir.out"
done

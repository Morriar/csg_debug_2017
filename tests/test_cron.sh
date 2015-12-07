#!/bin/bash

mkdir -p out/

echo -e "\nRun CRON tests..."
OK=0
KO=0
ALL=0

for input in $(ls cron/*.in); do
	ALL=$(($ALL + 1))

	file=$(basename "$input")
	name="${file%.*}"

	out="out/$name.out"
	exp="cron/$name.res"

	./run_cron.sh $(cat $input) > "$out" 2>&1

	diff -u -- "$out" "$exp" > "out/$name.diff"
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
else
	echo "All tests are OK!"
fi

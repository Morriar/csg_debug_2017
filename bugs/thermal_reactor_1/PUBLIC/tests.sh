#!/bin/bash

mkdir -p out/

echo "Compile bin..."
make compile > "out/compile.log" 2>&1
if [ "$?" -ne 0 ]; then
	echo " [FAIL] compile bin (cat out/compile.log)"
	exit 1
fi

echo -e "\nRun tests..."
OK=0
KO=0
ALL=0

for input in $(ls tests/*.in); do
	ALL=$(($ALL + 1))

	file=$(basename "$input")
	name="${file%.*}"

	out="out/$name.out"
	exp="tests/$name.res"

	java -cp bin/ ThermalConfigurator < "$input" > "$out" 2>&1

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

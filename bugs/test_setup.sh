#!/bin/bash

for bug in `find . -maxdepth 1 -mindepth 1 -type d`
do
	echo TESTING $bug
	pushd $bug/PRIVATE
	../PUBLIC/tests.sh
	popd
done

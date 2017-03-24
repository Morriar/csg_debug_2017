#!/bin/bash

if [ "$#" -ne 2 ]; then
	echo "usage: paste_fixes bugs_dir/ test_dir/"
	exit 1
fi

bugs_dir=$1
test_dir=$2

before=`pwd`
for bugdir in `ls -d $bugs_dir/*/`; do
	bug=`basename $bugdir`
	echo $bug
	cp -R $bugs_dir/$bug/PRIVATE/src/* $test_dir/$bug/src/
	cd $test_dir/$bug && git add * && git commit -m "test" && git push origin master && cd $before
done

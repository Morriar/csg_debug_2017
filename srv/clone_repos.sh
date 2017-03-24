#!/bin/bash

if [ "$#" -ne 2 ]; then
	echo "usage: clone_repos IP TEAM"
	exit 1
fi

ip=$1
teamid=$2

git clone ssh://$teamid@$ip:~/bug_hello
git clone ssh://$teamid@$ip:~/CalendarPersonalPlanner
git clone ssh://$teamid@$ip:~/Filther
git clone ssh://$teamid@$ip:~/FireMatches
git clone ssh://$teamid@$ip:~/ouija
git clone ssh://$teamid@$ip:~/PearMap
git clone ssh://$teamid@$ip:~/PegMobile
git clone ssh://$teamid@$ip:~/ROMCryption
git clone ssh://$teamid@$ip:~/solo
git clone ssh://$teamid@$ip:~/SuperSecretSafeSystemSolution
git clone ssh://$teamid@$ip:~/Wrottit

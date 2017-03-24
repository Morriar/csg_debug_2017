#!/bin/bash

if [ "$#" -ne 2 ]; then
	echo "usage: clone_repos IP TEAM"
	exit 1
fi

ip=$1
teamid=$2

git clone ssh://$teamid@$ip:/home/$teamid/bug_hello
git clone ssh://$teamid@$ip:/home/$teamid/CalendarPersonalPlanner
git clone ssh://$teamid@$ip:/home/$teamid/Filther
git clone ssh://$teamid@$ip:/home/$teamid/FireMatches
git clone ssh://$teamid@$ip:/home/$teamid/ouija
git clone ssh://$teamid@$ip:/home/$teamid/PearMap
git clone ssh://$teamid@$ip:/home/$teamid/PegMobile
git clone ssh://$teamid@$ip:/home/$teamid/ROMCryption
git clone ssh://$teamid@$ip:/home/$teamid/solo
git clone ssh://$teamid@$ip:/home/$teamid/SuperSecretSafeSystemSolution
git clone ssh://$teamid@$ip:/home/$teamid/Wrottit

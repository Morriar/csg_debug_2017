#!/bin/bash

if [ "$#" -ne 2 ]; then
	echo "usage: clone_repos IP TEAM"
	exit 1
fi

ip=$1
teamid=$2

cp id_rsa_debug ~/.ssh/id_rsa_debug
chmod 600 ~/.ssh/id_rsa_debug

echo "# Debug" >> ~/.ssh/config
echo "Host debug" >> ~/.ssh/config
echo "HostName $ip" >> ~/.ssh/config
echo "User $teamid" >> ~/.ssh/config

git clone ssh://debug/home/$teamid/bug_hello
git clone ssh://debug/home/$teamid/CalendarPersonalPlanner
git clone ssh://debug/home/$teamid/Filther
git clone ssh://debug/home/$teamid/FireMatches
git clone ssh://debug/home/$teamid/ouija
git clone ssh://debug/home/$teamid/PearMap
git clone ssh://debug/home/$teamid/PegMobile
git clone ssh://debug/home/$teamid/ROMCryption
git clone ssh://debug/home/$teamid/solo
git clone ssh://debug/home/$teamid/SuperSecretSafeSystemSolution
git clone ssh://debug/home/$teamid/Wrottit

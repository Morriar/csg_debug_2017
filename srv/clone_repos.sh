#!/bin/bash

if [ "$#" -ne 1 ]; then
	echo "usage: clone_repos TEAM"
	exit 1
fi

teamid=$2

git config --global user.email "$teamid"
git config --global user.name "$teamid"

git clone ssh://$teamid@debug.csgames:/home/$teamid/bug_hello
git clone ssh://$teamid@debug.csgames:/home/$teamid/CalendarPersonalPlanner
git clone ssh://$teamid@debug.csgames:/home/$teamid/Filther
git clone ssh://$teamid@debug.csgames:/home/$teamid/FireMatches
git clone ssh://$teamid@debug.csgames:/home/$teamid/ouija
git clone ssh://$teamid@debug.csgames:/home/$teamid/PearMap
git clone ssh://$teamid@debug.csgames:/home/$teamid/PegMobile
git clone ssh://$teamid@debug.csgames:/home/$teamid/ROMCryption
git clone ssh://$teamid@debug.csgames:/home/$teamid/solo
git clone ssh://$teamid@debug.csgames:/home/$teamid/SuperSecretSafeSystemSolution
git clone ssh://$teamid@debug.csgames:/home/$teamid/Wrottit

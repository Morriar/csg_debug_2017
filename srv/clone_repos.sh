#!/bin/bash

if [ "$#" -ne 2 ]; then
	echo "usage: clone_repos IP TEAM"
	exit 1
fi

teamip=$1
teamid=$2

cp id_rsa_debug ~/.ssh/id_rsa_debug
chmod 600 ~/.ssh/id_rsa_debug

echo "# Debug" >> ~/.ssh/config
echo "Host debug" >> ~/.ssh/config
echo "HostName $teamip" >> ~/.ssh/config
echo "Port 9291" >> ~/.ssh/config
echo "User $teamid" >> ~/.ssh/config
echo "IdentityFile ~/.ssh/id_rsa_debug" >> ~/.ssh/config
source ~/.profile

ssh-add ~/.ssh/id_rsa_debug

git clone ssh://debug/home/$teamid/access_panel
git clone ssh://debug/home/$teamid/alu_sim
git clone ssh://debug/home/$teamid/alveoli
git clone ssh://debug/home/$teamid/atomic_engine
git clone ssh://debug/home/$teamid/bug_hello
git clone ssh://debug/home/$teamid/domesec
git clone ssh://debug/home/$teamid/domefs
git clone ssh://debug/home/$teamid/doors
git clone ssh://debug/home/$teamid/irrigations
git clone ssh://debug/home/$teamid/power_grid
git clone ssh://debug/home/$teamid/militia_dispatch
git clone ssh://debug/home/$teamid/shield_gen
git clone ssh://debug/home/$teamid/thermal_reactor
git clone ssh://debug/home/$teamid/ventilation
git clone ssh://debug/home/$teamid/water_supply

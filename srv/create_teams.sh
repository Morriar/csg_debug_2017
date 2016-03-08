#!/bin/bash

create_user() {
	userid=$1
	userpw=$2
	cryptd=$(mkpasswd "$userpw")

	# create user
	# useradd -m -p "$cryptd" "$userid"
	useradd -s /usr/bin/git-shell -m -p "$cryptd" "$userid"

	# gen rsa key
	echo $userpw | sudo -s -u $userid ssh-keygen -C $userid -t rsa -f /home/$userid/.ssh/id_rsa -N $userpw
	echo $userpw | sudo -s -u $userid echo $(cat /home/$userid/.ssh/id_rsa.pub) >> /home/$userid/.ssh/authorized_keys
	chown $userid /home/$userid/.ssh/authorized_keys
	chgrp $userid /home/$userid/.ssh/authorized_keys

	# create key repo
	echo $userpw | sudo -s -u $userid mkdir /home/$userid/debug
	cp /home/ubuntu/csg_debug/srv/clone_repos.sh /home/$userid/debug/
	echo $userpw | sudo -s -u $userid cp /home/$userid/.ssh/id_rsa /home/$userid/debug/id_rsa_debug
	echo $userpw | sudo -s -u $userid git --git-dir /home/$userid/debug init --bare
	echo $userpw | sudo -s -u $userid git --git-dir /home/$userid/debug --work-tree /home/$userid/debug add /home/$userid/debug/clone_repos.sh
	echo $userpw | sudo -s -u $userid git --git-dir /home/$userid/debug --work-tree /home/$userid/debug add /home/$userid/debug/id_rsa_debug
	echo $userpw | sudo -s -u $userid git --git-dir /home/$userid/debug --work-tree /home/$userid/debug commit -m "Init repo"

	# protect all files in repo
	chmod -R 770 /home/$userid
}


if [ "$#" -ne 1 ]; then
	echo "usage: create_teams teams.csv"
	exit 1
fi

while IFS=$'\t' read -r -a user
do
	create_user "${user[0]}" "${user[1]}"
done < $1

#!/bin/bash

create_user() {
	userid=$1
	keys_dir=$2

	# create user
	useradd -s /usr/bin/git-shell -m -p "PASSword" "$userid"

	# add pub key
	mkdir /home/$userid/.ssh
	cat $keys_dir/__admin.key.pub >> /home/$userid/.ssh/authorized_keys # admins keys
	cat $keys_dir/$userid.key.pub >> /home/$userid/.ssh/authorized_keys

	# create key repo
	mkdir /home/$userid/debug
	cp srv/clone_repos.sh /home/$userid/debug/
	git --git-dir /home/$userid/debug init --bare
	git --git-dir /home/$userid/debug --work-tree /home/$userid/debug add /home/$userid/debug/clone_repos.sh
	git --git-dir /home/$userid/debug --work-tree /home/$userid/debug commit -m "Init repo"

	# protect all files in repo
	chmod -R 770 /home/$userid
	chown -R $userid /home/$userid
	chgrp -R $userid /home/$userid
}

if [ "$#" -ne 2 ]; then
	echo "usage: create_teams teams.lst keys_dir/"
	exit 1
fi

while IFS=$'\t' read -r -a user
do
	create_user "${user[0]}" $2
done < $1

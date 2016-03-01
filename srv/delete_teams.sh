#!/bin/bash

if [ "$#" -ne 1 ]; then
	echo "usage: delete_teams teams.csv"
	exit 1
fi

while IFS=$'\t' read -r -a user
do
	userdel "${user[0]}"
	rm -rf /home/"${user[0]}"
done < $1

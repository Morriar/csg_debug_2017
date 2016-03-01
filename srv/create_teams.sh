#!/bin/bash

if [ "$#" -ne 1 ]; then
	echo "usage: create_teams teams.csv"
	exit 1
fi

while IFS=$'\t' read -r -a user
do
	./create_user.sh "${user[0]}" "${user[1]}"
done < $1

#!/bin/bash

while IFS=$'\t' read -r -a user
do
	userdel "${user[0]}"
	rm -rf /home/"${user[0]}"
done < teams.csv

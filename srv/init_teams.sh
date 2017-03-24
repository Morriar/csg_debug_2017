#!/bin/bash

if [ "$#" -ne 2 ]; then
	echo "usage: init_teams teams.csv deploy_dir"
	exit 1
fi

while IFS=$'\t' read -r -a user
do
	team=${user[0]}

	team_dir=$2/$team

	for bug in bug_hello CalendarPersonalPlanner Filther FireMatches ouija PearMap PegMobile ROMCryption solo SuperSecretSafeSystemSolution Wrottit; do
		bug_origin=$team_dir/${bug}_origin
		# Set permissions
		chown -R $team $bug_origin;
		chgrp -R $team $bug_origin;
		# Create home link
		ln -fs $bug_origin /home/$team/$bug
		chown -R $team /home/$team/$bug;
		chgrp -R $team /home/$team/$bug;
	done
done < $1
chmod -R 751 $2;

#!/bin/bash

if [ "$#" -ne 2 ]; then
	echo "usage: init_teams teams.csv deploy_dir"
	exit 1
fi

while IFS=$'\t' read -r -a user
do
	team=${user[0]}
	pass=${user[1]}

	team_dir=$2/$team

	for bug in access_panel alveoli alu_sim atomic_engine bug_hello domesec domefs doors irrigations militia_dispatch power_grid shield_gen thermal_reactor ventilation water_supply; do
		bug_origin=$team_dir/${bug}_origin
		# Set permissions
		chown -R $team $bug_origin;
		chgrp -R $team $bug_origin;
		# Create home link
		echo $pass | sudo -s -u $team ln -fs $bug_origin /home/$team/$bug
	done
done < $1
chmod -R 751 $2;

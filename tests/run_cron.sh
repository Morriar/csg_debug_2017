#!/bin/bash

if [ $# -ne 2 ]; then
	echo "usage:\n"
	echo "run_cron.sh teams.json bugs/"
	exit 1
fi

teams=$1
bugs=$2

# Load db
node ../tools/load_db.js csg_debug teams $teams
node ../tools/load_db.js csg_debug bugs data/bugs.json

# Deploy teams
nit ../tools/deploy_teams.nit $teams $bugs out/

# Run cron
node ../cron/cron.js csg_debug 10 0.1

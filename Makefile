check:
	make test-bugs -C tests/

load-teams:
	node src/loadTeams.js teams.json
	node src/loadBugs.js bugs/ data/bugs.json
	node src/deployTeams.js bugs/ teams_repos/

start-scoreboard:
	make start-scoreboard -C src/

start-cron:
	make start-cron -C src/

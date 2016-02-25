help:
	@echo "usage:"
	@echo " * install		install all required dependencies (need sudo)"
	@echo " * check		check all bugs"
	@echo " * load-teams		load & deploy teams from teams.json and bugs.json"
	@echo " * start-scoreboard	start the scoreboard web server"
	@echo " * start-cron		start the cron & the competition"

install:
	./install.sh

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

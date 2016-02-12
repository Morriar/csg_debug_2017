all: test-bugs test-cron

test-bugs:
	./test_bugs.sh

test-cron:
	node ../src/loadTeams.js data/teams_1.json
	node ../src/loadBugs.js ../bugs
	node ../src/deployTeams.js ../bugs out/
	node ../src/cron.js out/ 3 5

clean:
	rm -rf out/

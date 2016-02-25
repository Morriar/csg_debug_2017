all: test-bugs test-cron

test-bugs:
	./test_bugs.sh

test-cron: test-cron-private test-cron-public

test-cron-private:
	node ../src/loadTeams.js data/teams_1.json
	node ../src/loadBugs.js ../bugs
	node ../src/deployTeams.js ../bugs out/ PRIVATE
	node ../src/cron.js out/ 11 15

test-cron-public:
	node ../src/loadTeams.js data/teams_1.json
	node ../src/loadBugs.js ../bugs
	node ../src/deployTeams.js ../bugs out/ PUBLIC
	node ../src/cron.js out/ 11 15

clean:
	rm -rf out/

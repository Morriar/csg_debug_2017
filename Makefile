# Copyright 2016 Alexandre Terrasa <alexandre@moz-code.org>.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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

init-compe:
	sudo rm -rf DEPLOY
	sudo ./srv/delete_teams.sh teams.csv
	sudo ./srv/create_teams.sh teams.csv
	node src/loadRounds.js
	node src/loadStatus.js
	node src/loadTeams.js teams.json
	node src/loadBugs.js bugs/
	node src/deployTeams.js bugs/ DEPLOY/ PUBLIC
	sudo ./srv/init_teams.sh teams.csv /home/ubuntu/csg_debug/DEPLOY/

start-scoreboard:
	node src/bin/www

start-cron:
	node src/cron.js DEPLOY 35 300

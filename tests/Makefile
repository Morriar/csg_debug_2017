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

all: test-bugs test-cron

test-bugs:
	./test_bugs.sh

test-cron: test-cron-private test-cron-public

test-cron-private:
	node ../src/loadStatus.js
	node ../src/loadRounds.js
	node ../src/loadTeams.js data/teams_1.json
	node ../src/loadBugs.js ../bugs
	node ../src/deployTeams.js ../bugs out/ PRIVATE
	node ../src/cron.js out/ 11 15

test-cron-public:
	node ../src/loadStatus.js
	node ../src/loadRounds.js
	node ../src/loadTeams.js data/teams_1.json
	node ../src/loadBugs.js ../bugs
	node ../src/deployTeams.js ../bugs out/ PUBLIC
	node ../src/cron.js out/ 11 15

clean:
	rm -rf out/

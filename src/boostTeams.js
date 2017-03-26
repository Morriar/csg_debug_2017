//  Copyright 2015 Alexandre Terrasa <alexandre@moz-code.org>.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

var teams = require('./model/teams.js');

// Clear db and create teams
function deployTeams() {
	teams.find({}, function(ts) {
		ts.forEach(function(team) {
			console.log("Boost team " + team.id);
			team.oxygen += 300;
			team.energy += 300;
			teams.save(team);
		});
		console.log("Boosted " + ts.length + " teams");
		process.exit(0);
	});
}

deployTeams();

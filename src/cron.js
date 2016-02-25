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

// The Cron pings all teams at a set interval and update game data.

var teams = require("./model/teams.js");
var bugs = require("./model/bugs.js");
var rounds = require("./model/rounds.js");
var tests = require("./model/tests.js");
var statuses = require("./model/status.js");
var fs = require("fs");

// Create a new round or stop the game if maxRounds is reached.
function newRound(roundNumber, roundDuration, maxRounds) {
	if(currentRound > maxRounds) {
		rounds.create(currentRound, roundDuration, true);
		process.exit(0);
	}
	var round = rounds.create(currentRound, roundDuration);
	console.log("\n# Round " + currentRound + " / " + maxRounds + " (" + roundDuration + "s)");
	return round;
}

// Play round for each team
function playRound(teamsDir, round) {
	teams.find({}, function(allteams) {
		bugs.find({}, function(allbugs) {
			allteams.forEach(function(team) {
				applyRoundLoss(round, team, allbugs, function(teamsDir, round, team, allbugs) {
					applyBugs(teamsDir, round, team, allbugs, function(team, result) {
						show_team(team, result);
					});
				});
			});
		});
	});
}

// Apply loss in energy and oxygen for a team.
function applyRoundLoss(round, team, bs, callback) {
	// Apply round loss
	team.oxygen = team.oxygen - o2_loss;
	team.energy = team.energy - z_loss;

	// Kill teams
	if(team.oxygen <= 0 || team.energy <= 0) {
		team.isDead = true;
		team.oxygen = 0;
		team.energy = 0;
	} else if(team.oxygen <= 25 || team.energy <= 25) {
		team.inDanger = true;
	} else {
		team.inDanger = false;
	}
	teams.save(team);
	callback(teamsDir, round, team, bs);
}

function applyBugs(teamsDir, round, team, bs, callback) {
	tests.testTeam(teamsDir, round, team, bs, function(status) {
		if(status.bugs) {
			Object.keys(status.bugs).forEach(function(bugId) {
				var result = status.bugs[bugId];
				if(result.status == "success") {
					team.oxygen = team.oxygen + result.object.o2boost;
					team.energy = team.energy + result.object.zboost;
					team.score = team.score + result.object.score_bonus;
				}
			});
		}
		if(team.oxygen > 100) { team.oxygen = 100; }
		if(team.energy > 100) { team.energy = 100; }
		teams.save(team);
		statuses.save(status);
		callback(team, status)
	});
}

function show_team(team, result) {
	var status = ' * ' + team.id +
				' (o2:' + team.oxygen +
				', z: ' + team.energy +
				', s: ' + team.score + ')';
	if(team.error) {
		console.log(status + ' ERROR: ' + team.error);
	} else if(team.isDead) {
		console.log(status + ' dead');
	} else {
		console.log(status);
	}
	Object.keys(result.bugs).forEach(function(bugId) {
		var r = result.bugs[bugId];
		if(r.status == 'success') {
			console.log("   [OK] " + bugId);
		} else {
			console.log("   [KO] " + bugId);
		}
	});
}

var argv = process.argv;
if(argv.length != 5) {
	console.log("usage:\n");
	console.log("node cron.js teams_dir max_rounds round_duration");
	process.exit(1);
}

// Rules config
var teamsDir = argv[2];
var maxRounds = argv[3];
var currentRound = 1;
var roundDuration = parseInt(argv[4]);
var o2_loss = 10;
var z_loss = 10;

rounds.drop();
statuses.drop();

// Database
teams.find({}, function(teams) {
	console.log("# Start game (" + maxRounds + " rounds, " + teams.length + " teams)");

	// Start cron
	var round = newRound(currentRound, roundDuration, maxRounds);
	playRound(teamsDir, round);
	setInterval(function() {
		currentRound += 1;
		var round = newRound(currentRound, roundDuration, maxRounds);
		playRound(teamsDir, round);
	}, roundDuration * 1000);
});

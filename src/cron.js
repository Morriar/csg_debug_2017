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

var fs = require("fs");
var request = require('request');
var mongo = require('mongoskin');
var async = require('async');

// Load teams and callback(teams);
function loadTeams(db, callback) {
	db.collection("teams").find().toArray(function(err, teams) {
		if(err) {
			console.log(err);
			teams = [];
		}
		callback(teams);
	});
}

function applyRound(team, status, callback) {
	db.collection("status").insert(status);

	// Apply round loss
	team.oxygen = team.oxygen - o2_loss;
	team.energy = team.energy - z_loss;

	if(status.bugs) {
		status.bugs.forEach(function(bug) {
			if(bug.status == "success") {
				team.oxygen = team.oxygen + bug.o2boost;
				team.energy = team.energy + bug.zboost;
				team.score = team.score + bug.score_bonus
			}
		});
	}

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
	db.collection("teams").save(team);

	if(status.error) {
		team.error = status.error
	}
	callback(null, team);
}

// Ping team and callback(team, json_status)
function pingTeam(round, team, callback) {
	var team_uri = 'http://localhost:' + team.port + '/round';
	request({uri: team_uri, timeout: 99999}, function(err, res, body) {
		if(err) {
			applyRound(team, {
				round: round.round,
				team: team.id,
				timestamp: new Date().getTime(),
				error: err.message
			}, callback);
		} else {
			var json = JSON.parse(body);
			json.round = round.round;
			applyRound(team, json, callback);
		}
	});
}

// Ping all `teams` and callback(results)
function pingTeams(round, teams, callback) {
	var calls = [];
	teams.forEach(function(team) {
		calls.push(function(callback) {
			pingTeam(round, team, callback);
		});
	});
	async.parallel(calls, function(err, results) {
		if(err) {
			res.json({err: err.message});
			return;
		};
		callback(results);
	});
}

function playRound(db, round) {
	loadTeams(db, function(teams) {
		pingTeams(round, teams, function(results) {
			console.log('\n## ROUND ' + round.round);
			results.forEach(function(team) {
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
			});
		});
	});
}

function newRound(db, roundNumber, duration, finished) {
	var round = {
		round: roundNumber,
		startedAt: new Date().getTime(),
		duration: duration
	}
	if(finished) {
		round.gameFinished = true
	}
	db.collection("rounds").insert(round);
	return round;
}

var argv = process.argv;
if(argv.length != 5) {
	console.log("usage:\n");
	console.log("node cron.js db_name max_rounds round_duration");
	process.exit(1);
}

// Rules config
var maxRounds = argv[3];
var currentRound = 1;
var roundDuration = argv[4];
var o2_loss = 10;
var z_loss = 10;

// Database
var db_name = argv[2];
var db = mongo.db('mongodb://localhost:27017/' + db_name)

loadTeams(db, function(teams) {
	console.log("# Start game (" + maxRounds + " rounds, " + teams.length + " teams)");

	// Start cron
	var round = newRound(db, currentRound, roundDuration);
	playRound(db, round);
	setInterval(function() {
		currentRound += 1;
		if(currentRound > maxRounds) {
			newRound(db, currentRound, roundDuration, true);
			process.exit(0);
		}
		var round = newRound(db, currentRound, roundDuration);
		db.collection("rounds").insert(round);
		playRound(db, round);
	}, roundDuration * 1000);
});

var fs = require("fs");
var request = require('request');
var mongo = require('mongoskin');

function pingTeams(db, round, bugs) {
	db.collection("teams").find({}).each(function(err, team) {
		if(!team) { return; }

		if(team.isDead) {
			console.log(' * ' + team.id + ' (dead)');
			return;
		}

		request({uri: 'http://localhost:' + team.port + '/round', timeout: 1000}, function(err, res, body) {
			// Apply round loss
			team.oxygen = team.oxygen - o2_loss;
			team.energy = team.energy - z_loss;

			// Wrapper don't respond... What TODO?
			var status;
			if(err) {
				// console.log(err);
				status = {
					team: team.id,
					timestamp: new Date().getTime(),
					error: err.message
				};
			} else {
				status = JSON.parse(body);
				// Apply bugs bonuses
				status.bugs.forEach(function(bug) {
					if(bug.status == "success") {
						var slot = bugs[bug.bug];
						team.oxygen = team.oxygen + slot.o2boost;
						team.energy = team.energy + slot.zboost;
						team.score = team.score + slot.score_bonus
					}
				});
			}
			status.round = round;
			db.collection("status").insert(status);

			// Kill teams
			if(team.oxygen <= 0 || team.energy <= 0) {
				team.isDead = true;
				team.oxygen = 0;
				team.energy = 0;
			}
			db.collection("teams").save(team);

			console.log(' * ' + team.id +
				' (o2:' + team.oxygen +
				', e: ' + team.energy +
				', s: ' + team.score + ')');
		});
	});
}

var argv = process.argv;
if(argv.length != 3) {
	console.log("usage:\n");
	console.log("node cron.js db_name");
	process.exit(1);
}

// Rules config
var maxRounds = 10;
var currentRound = 0;
var roundDuration = 2;
var o2_loss = 10;
var z_loss = 10;

// Database
var db_name = argv[2];
var db = mongo.db('mongodb://localhost:27017/' + db_name)

// Start cron
setInterval(function() {
	if(currentRound >= maxRounds) {
		process.exit(0);
	}
	currentRound += 1;
	console.log('\n## ROUND ' + currentRound + ' / ' + maxRounds);
	db.collection('bugs').find({}).toArray(function(err, bug_list) {
		var bugs = {};
		bug_list.forEach(function(bug ) {
			bugs[bug.id] = bug;
		});

		pingTeams(db, currentRound, bugs);
	});
}, roundDuration * 1000);

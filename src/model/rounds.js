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

// rounds db handling

var db = require('mongoskin').db('mongodb://localhost:27017/csg_debug');
db.bind('rounds');

exports.create = function(roundNumber, duration, finished) {
	var round = {
		round: roundNumber,
		startedAt: new Date().getTime(),
		duration: duration,
		hideScoreboard: roundNumber >= 30
	}
	if(finished) {
		round.gameFinished = true
	}
	db.rounds.insert(round);
	return round;
}

// Load rounds and callback(rounds);
exports.find = function(req, callback) {
	db.rounds.find(req).sort({score: -1}).toArray(function(err, rounds) {
		if(err) {
			console.log(err);
			rounds = [];
		}
		callback(rounds);
	});
}

// Load a round by its id and callback(round);
exports.findOne = function(round_id, callback) {
	db.rounds.findOne({id: round_id}, function(err, round) {
		callback(round);
	});
}

// Load last round;
exports.findLast = function(callback) {
	db.rounds.find().sort({round: -1}).toArray(function(err, rounds) {
		callback(rounds[0]);
	});
}

// Drop all rounds.
exports.drop = function() {
	db.rounds.drop();
}

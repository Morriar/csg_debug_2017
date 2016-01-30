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

// Scoreboard: displays the team scores and domes.

var express = require('express');
var request = require('request');
var teams = require('../model/teams');
var rounds = require('../model/rounds');
var status = require('../model/status');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
	rounds.findLast(function(round) {
		teams.find({}, function(teams) {
			res.render('index', { title: 'Debug Competition', round: round, teams: teams });
		});
	});
});

/* GET rules page. */
router.get('/rules', function(req, res, next) {
	res.render('rules', { title: 'Debug Competition' });
});

/* GET dome page. */
router.get('/team/:tid', function(req, res, next) {
	var tid = req.params.tid;
	if(!tid) {
		res.redirect('/');
		return;
	}
	rounds.findLast(function(round) {
		teams.findOne(tid, function(team) {
			if(!team) {
				res.redirect('/');
				return;
			}
			console.log(team.id);
			status.find({team: team.id}, 1, function(status) {
				console.log(status);
				if(status.length == 0) {
					res.redirect('/');
					return;
				}
				res.render('dome', {
					title: 'Debug Competition',
					team: team,
					round: round,
					status: status[0]
				});
			});
		});
	});
});

/* GET bug page. */
router.get('/team/:tid/:bid', function(req, res, next) {
	var tid = req.params.tid;
	var bid = req.params.bid;
	if(!tid || !bid) {
		res.redirect('/');
		return;
	}
	status.find({team: tid}, 50, function(status) {
		var rounds = {};
		status.forEach(function(round) {
			if(!round.bugs) { return; }
			round.bugs.forEach(function(bug) {
				if(bug.id !== bid) { return; }
				bug.team = round.team;
				bug.timestamp = round.timestamp;
				rounds[round.round] = bug;
			});
		});
		res.render('bug', {bug_id: bid, rounds: rounds});
	});
});

module.exports = router;

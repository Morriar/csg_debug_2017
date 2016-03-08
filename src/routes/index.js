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
var markdown = require('markdown').markdown;
var teams = require('../model/teams');
var bugs = require('../model/bugs');
var rounds = require('../model/rounds');
var statuses = require('../model/status');
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

/* GET regles page. */
router.get('/regles', function(req, res, next) {
	res.render('regles', { title: 'Compétition Deboggage' });
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
			bugs.find({}, function(bugs) {
				statuses.find({team: team.id}, 1, function(status) {
					res.render('dome', {
						title: 'Debug Competition',
						team: team,
						round: round,
						bugs: bugs,
						status: status.length == 0 ? null : status[0]
					});
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
	bugs.findOne(bid, function(bug) {
		if(!bug) {
			res.redirect('/');
			return;
		}
		statuses.find({team: tid}, 50, function(status) {
			var list = {};
			var last = null;
			if(status.length != 0) {
				last = status[0].bugs[bug.id]
			}
			status.forEach(function(s) {
				var ss = {
					team: s.team,
					timestamp: s.timestamp,
					status: s.bugs[bug.id]
				}
				list[s.round.round] = ss;
			});
			var html = markdown.toHTML(bug.readme);
			res.render('bug', {bug: bug, rounds: list.length == 0 ? null : list, last: last, readme: html});
		});
	});
});

module.exports = router;

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

// JSON routes for ajax reload.

var express = require('express');
var request = require('request');
var teams = require('../model/teams');
var bugs = require('../model/bugs');
var rounds = require('../model/rounds');
var statuses = require('../model/status');
var router = express.Router();

router.get('/round', function(req, res, next) {
	rounds.findLast(function(round) {
		if(round) {
			round.now = new Date().getTime();
		}
		res.json(round);
	});
});

router.get('/team/:tid', function(req, res, next) {
	var tid = req.params.tid;
	if(!tid) {
		res.json({ error: "bad input" }, 503);
		return;
	}
	teams.findOne(tid, function(team) {
		if(!team) {
			res.json({ error: "team not found" }, 404);
			return;
		}
		res.json(team);
	});
});

router.get('/status/:tid', function(req, res, next) {
	var tid = req.params.tid;
	if(!tid) {
		res.json({ error: "bad input" }, 503);
		return;
	}
	statuses.find({team: tid}, 1, function(status) {
		res.json(status[0]);
	});
});

module.exports = router;

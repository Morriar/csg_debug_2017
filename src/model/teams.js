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

// teams db handling

var db = require('mongoskin').db('mongodb://localhost:27017/csg_debug');
db.bind('teams');

// Load teams and callback(teams);
exports.find = function(req, callback) {
	db.teams.find(req).sort({score: -1}).toArray(function(err, teams) {
		if(err) {
			console.log(err);
			teams = [];
		}
		callback(teams);
	});
}

// Load a team by its id and callback(team);
exports.findOne = function(team_id, callback) {
	db.teams.findOne({id: team_id}, function(err, team) {
		callback(team);
	});
}

// Save a team.
exports.save = function(team) {
	db.teams.save(team);
}

// Drop all teams.
exports.drop = function() {
	db.teams.drop();
}

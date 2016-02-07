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
//  See the License for the specific language governing perbugs and
//  limitations under the License.

// bugs db handling

var fs = require('fs');
var db = require('mongoskin').db('mongodb://localhost:27017/csg_debug');
db.bind('bugs');

// Load bugs and callback(bugs);
exports.find = function(req, callback) {
	db.bugs.find(req).toArray(function(err, bugs) {
		if(err) {
			console.log(err);
			bugs = [];
		}
		callback(bugs);
	});
}

// Load a bug by its id and callback(bug);
exports.findOne = function(bug_id, callback) {
	db.bugs.findOne({id: bug_id}, function(err, bug) {
		callback(bug);
	});
}

// Save a big in the database.
exports.save = function(bug) {
	db.bugs.insert(bug);
}

// Drop all bugs.
exports.drop = function() {
	db.bugs.drop();
}

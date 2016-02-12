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

// status db handling

var db = require('mongoskin').db('mongodb://localhost:27017/csg_debug');
db.bind('status');

// Load status and callback(status);
exports.find = function(req, limit, callback) {
	db.status.find(req).sort({timestamp: -1}).limit(limit).toArray(function(err, status) {
		if(err) {
			console.log(err);
			status = [];
		}
		callback(status);
	});
}

// Load a status by its id and callback(status);
exports.findOne = function(status_id, callback) {
	db.status.findOne({id: status_id}, function(err, status) {
		callback(status);
	});
}

// Insert a new status.
exports.save = function(status) {
	db.status.insert(status);
}

// Drop all status.
exports.drop = function() {
	db.status.drop();
}

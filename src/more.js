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

// Use this tool to load the database with a team json file.
//
// usage:
//	node loadTeams.js /path/to/json

var db = require('mongoskin').db('mongodb://localhost:27017/csg_debug');
db.bind('teams');

teams.find({}, function(ts) {
	teams.each(function(t) {
		t.oxygen += 200;
		t.energy += 200;
		teams.save(t);
	});
	process.exit(0);
});

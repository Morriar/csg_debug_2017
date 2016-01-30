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

// Use this tool to load the database with a json file.
//
// usage:
//	node load_db.js db_name collection_name /path/to/json
//
// Pass "drop" as filename to drop the database:
//	node load_db.js db_name collection_name drop

var fs = require("fs");
var mongo = require('mongoskin');

// Insert items into db.collection.
function load_collection(db, collection, items) {
	db.collection(collection).drop();
	for(i in items) {
		db.collection(collection).insert(items[i]);
	}
	db.collection(collection).count(function(err, count) {
		console.log("Loaded " + count + " " + collection +"...")
		process.exit(0);
	});
}

// Read a file and parse it as json.
function readJsonFile(file) {
	return JSON.parse(fs.readFileSync(file, 'utf-8'));
}

var argv = process.argv;

if(argv.length != 5) {
	console.log("usage:\n");
	console.log("node load_db.js db_name collection_name path/to/json");
	process.exit(1);
}

var db_name = argv[2];
var collection_name = argv[3];
var file = argv[4];

var db = mongo.db('mongodb://localhost:27017/' + db_name)

if(file === "drop") {
	load_collection(db, collection_name, []);
} else {
	load_collection(db, collection_name, readJsonFile(file));
}

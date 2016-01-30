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

var fs = require("fs");
var mongo = require('mongoskin');
var proc = require("child_process");

// Clear db and create teams
function init(base_dir, teams_file, bugs_file) {
	var db = mongo.db('mongodb://localhost:27017/csg_debug')
	db.collection("bugs").drop();
	db.collection("teams").drop();

	var teams = readJsonFile(teams_file);
	var bugs = loadBugs(db, readJsonFile(bugs_file));

	proc.execSync("rm -rf " + base_dir);
	fs.mkdirSync(base_dir);

	teams.forEach(function(team) {
		createTeam(base_dir, db, team, bugs);
	});

	db.collection("teams").count(function(err, count) {
		console.log("Loaded " + count + " teams...")
		process.exit(0);
	});}

function readJsonFile(file) {
	return JSON.parse(fs.readFileSync(file, 'utf-8'));
}

// Teams

function createTeam(base_dir, db, team, bugs) {
	mkdirTeam(base_dir, team);
	bugs.forEach(function(bug) {
		var tbug_dir = base_dir + '/' + team.id + '/' + bug.id;
		fs.mkdirSync(tbug_dir);
		proc.execSync("make -C " + bug.dir + '/PUBLIC/ clean');
		proc.execSync("cp -r " + bug.dir + '/PUBLIC/* ' + tbug_dir);
	});
	db.collection("teams").insert(team);
	console.log("* Loaded team " + team.id);
}

function mkdirTeam(base_dir, team) {
	fs.mkdirSync(base_dir + '/' + team.id);
}

// Bugs

function loadBugs(db, bugs_list) {
	var bugs = [];
	bugs_list.forEach(function(bug_dir) {
		var bug = readJsonFile(bug_dir + '/bug.json');
		bug.dir = bug_dir;
		db.collection("bugs").insert(bug);
		bugs.push(bug);
	});
	return bugs;
}

var argv = process.argv;

if(argv.length != 4) {
	console.log("usage:\n");
	console.log("node deploy_teams.js teams.json bugs.json");
	process.exit(1);
}

init("teams/", argv[2], argv[3])

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
var proc = require("child_process");
var teams = require('./model/teams.js');
var bugs = require('./model/bugs.js');

// Clear db and create teams
function deployTeams(bugs_dir, teams_dir, version) {
	proc.execSync("rm -rf " + teams_dir);
	fs.mkdirSync(teams_dir);

	teams.find({}, function(ts) {
		bugs.find({}, function(bs) {
			ts.forEach(function(team) {
				createTeamDir(bugs_dir, teams_dir, team, bs, version);
			});
			console.log("Loaded " + bs.length + " bugs in " + ts.length + " teams")
			process.exit(0);
		});
	});
}

// Create the team directory and each bug in it.
function createTeamDir(bugs_dir, teams_dir, team, bs, version) {
	fs.mkdirSync(teams_dir + '/' + team.id);
	bs.forEach(function(bug) {
		var tbug_dir = teams_dir + '/' + team.id + '/' + bug.id;
		fs.mkdirSync(tbug_dir);
		proc.execSync("make -C " + bugs_dir + '/' + bug.dir + '/' + version + '/ clean');
		proc.execSync("cp -r " + bugs_dir + '/' + bug.dir + '/' + version + '/* ' + tbug_dir);
		proc.execSync("cp -r " + bugs_dir + '/' + bug.dir + '/PRIVATE/tests/* ' + tbug_dir + '/tests/');
	});
}

var argv = process.argv;

if(argv.length != 5) {
	console.log("usage:\n");
	console.log("node deployTeams.js bugs/dir deploy/dir VERSION");
	process.exit(1);
}

deployTeams(argv[2], argv[3], argv[4])

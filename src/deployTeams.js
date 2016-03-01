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
function deployTeams(bugs_dir, teams_dir, version, prod) {
	proc.execSync("rm -rf " + teams_dir);
	fs.mkdirSync(teams_dir);

	teams.find({}, function(ts) {
		bugs.find({}, function(bs) {
			ts.forEach(function(team) {
				createTeamDir(bugs_dir, teams_dir, team, bs, version, prod);
			});
			console.log("Loaded " + bs.length + " bugs in " + ts.length + " teams")
			process.exit(0);
		});
	});
}

// Create the team directory and each bug in it.
function createTeamDir(bugs_dir, teams_dir, team, bs, version, prod) {
	fs.mkdirSync(teams_dir + '/' + team.id);
	bs.forEach(function(bug) {
		var bug_dir = teams_dir + '/' + team.id + '/' + bug.id;
		var bug_private = bug_dir + '_private';
		var bug_origin = bug_dir + '_origin';
		// copy private version (used for private tests)
		fs.mkdirSync(bug_private);
		proc.execSync("make -C " + bugs_dir + '/' + bug.dir + '/PRIVATE/ clean');
		proc.execSync("cp -r " + bugs_dir + '/' + bug.dir + '/PRIVATE/* ' + bug_private);
		// create origin repo and clone public version
		fs.mkdirSync(bug_origin);
		proc.execSync("cd " + bug_origin + " && git init --bare");
		proc.execSync("git clone -q " + bug_origin + " " + bug_dir + " 2>&1")
		// copy public version (the one given to participants)
		proc.execSync("make -C " + bugs_dir + '/' + bug.dir + '/' + version + '/ clean');
		proc.execSync("cp -r " + bugs_dir + '/' + bug.dir + '/' + version + '/* ' + bug_dir);
		// Init git repo
		proc.execSync("cd " + bug_dir + " && git add -A && git commit -m 'Initial Commit'");
		proc.execSync("cd " + bug_dir + " && git push origin master -uq");
	});
}

var argv = process.argv;

if(argv.length < 5) {
	console.log("usage:\n");
	console.log("node deployTeams.js bugs/dir deploy/dir VERSION");
	console.log("add arg `PROD` to manage user rights");
	process.exit(1);
}

deployTeams(argv[2], argv[3], argv[4], argv[5])

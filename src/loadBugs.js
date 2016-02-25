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

// Use this tool to load the database from a bug directory.
//
// usage:
//	node loadBugs.js bugs.json

var fs = require("fs");
var bugs = require('./model/bugs.js');
var path = require('path');

function loadTestFiles(dir) {
  var res = [];
  var files = fs.readdirSync(dir);
  for(i in files) {
    var file = files[i];
	if(path.extname(file) == '.res') { continue; }
	var name = path.basename(file, '.in')
	res.push({
	  name: name,
	  path: dir + file
	});
  }
  return res;
}

function loadReadme(path) {
	return fs.readFileSync(path, 'utf-8');
}

var argv = process.argv;

if(argv.length != 3) {
	console.log("usage:\n");
	console.log("node loadBugs.js bugs/dir");
	process.exit(1);
}

var bugs_dir = argv[2];
var json = JSON.parse(fs.readFileSync(bugs_dir + '/bugs.json', 'utf-8'));

bugs.drop();
json.forEach(function(bug_dir) {
	var bug_json = JSON.parse(fs.readFileSync(bugs_dir + '/' + bug_dir + '/bug.json', 'utf-8'));
	bug_json.dir = bug_dir;
	bug_json.readme = loadReadme(bugs_dir + '/' + bug_dir + '/PUBLIC/README.md')
	bug_json.tests = loadTestFiles(bugs_dir + '/' + bug_dir + '/PRIVATE/tests/');
	bugs.save(bug_json);
});
bugs.find({}, function(bs) {
	console.log("Loaded " + bs.length + " bugs.")
	process.exit(0);
});

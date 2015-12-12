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

// Wrapper is responsible of building and testing all binaries of a team.

var express = require('express');
var fs = require('fs');
var path = require('path');
var router = express.Router();
var md = require('node-markdown').Markdown;
var child_process = require('child_process');
var request = require('request');
var async = require('async');

// Load a bug by its name.
//
// Looks into `bugs_dir' + '/' + bug_name`.
function loadBug(bugs_dir, bug_name) {
  var bug_path = bugs_dir + '/' + bug_name;
  var config_path = bug_path + '/bug.json';
  var bug_config = JSON.parse(fs.readFileSync(config_path, 'UTF-8'));
  return {
	name: bug_name,
	path: bug_path,
	config: bug_config
  };
}

// List all known bugs.
//
// Looks into `bugs_dir`.
function listBugs(bugs_dir) {
  var res = [];
  var dirs = fs.readdirSync(bugs_dir);
  for(i in dirs) {
    var bug_name = dirs[i];
	var config_path = bugs_dir + '/' + bug_name + '/bug.json';
	if(!fs.existsSync(config_path)) { continue; }
	res.push(loadBug(bugs_dir, bug_name));
  }
  return res;
}

function loadTestFiles(version, dir) {
  var res = [];
  var files = fs.readdirSync(dir);
  for(i in files) {
    var file = files[i];
	if(path.extname(file) == '.res') { continue; }
	var name = path.basename(file, '.in')
	res.push({
	  name: name,
      version: version,
	  path: dir + file
	});
  }
  return res;
}

/* GET home page. */
router.get('/', function(req, res, next) {
  var team = req.app.get('team');
  var bugs = listBugs(req.app.get('bugs_dir'));
  res.render('team', { team: team, bugs: bugs });
});

/* GET bug page. */
router.get('/bugs/:bug', function(req, res, next) {
  var team = req.app.get('team');
  var bug = loadBug(req.app.get('bugs_dir'), req.params.bug);
  var public = loadTestFiles('PUBLIC', bug.path + '/PUBLIC/tests/');
  var private = loadTestFiles('PRIVATE', bug.path + '/PRIVATE/tests/');
  res.render('bug', { team: team, bug: bug, public: public, private: private });
});

/* GET bug readmes page. */
router.get('/bugs/:bug/readmes', function(req, res, next) {
  var team = req.app.get('team');
  var bug = loadBug(req.app.get('bugs_dir'), req.params.bug);
  var public = md(fs.readFileSync(bug.path + '/PUBLIC/README.md', 'UTF-8'));
  var private = md(fs.readFileSync(bug.path + '/PRIVATE/README.md', 'UTF-8'));
  res.render('readmes', { team: team, bug: bug, public: public, private: private });
});

/* GET view test page. */
router.get('/bugs/:bug/tests/:version/:test', function(req, res, next) {
  var team = req.app.get('team');
  var bug = loadBug(req.app.get('bugs_dir'), req.params.bug);
  var version = req.params.version;
  var test_name = req.params.test;
  var tests_dir = bug.path + '/' + version + '/tests/';
  var input = fs.readFileSync(tests_dir + '/' + test_name + '.in', 'UTF-8')
  var exp = fs.readFileSync(tests_dir + '/' + test_name + '.res', 'UTF-8')
  res.render('test', { team: team, bug: bug, input: input, exp: exp });
});

// TODO add PULL action

/* GET build version. */
router.get('/bugs/:bug/build/:version', function(req, res, next) {
  var team = req.app.get('team');
  var bug = loadBug(req.app.get('bugs_dir'), req.params.bug);
  var version = req.params.version
  child_process.exec('make compile-batch -sB -C ' + bug.path + "/" + version, function(err, stdout, stderr) {
	  var obj = {}
	  if(err) {
		  obj.status = 'failure',
		  obj.message = stderr
	  } else {
		  obj.status = 'success'
	  }
	  res.json(obj);
  });
});

/* GET test version with random test input. */
router.get('/bugs/:bug/test/:version', function(req, res, next) {
  var team = req.app.get('team');
  var bug = loadBug(req.app.get('bugs_dir'), req.params.bug);
  var version = req.params.version
  var tests = loadTestFiles(version, bug.path + "/" + version + '/tests/');
  var rand = tests[Math.floor(Math.random() * tests.length)];
  var url = req.protocol + '://' + req.get('host') + '/bugs/' + bug.name + '/test/' + version + '/' + rand.name;
  request.get(url , function (err, resp, body) {
    if(err) {
		res.json({error: err.message, resp: resp, body: body});
	} else {
		res.json(JSON.parse(body));
	}
  });
});

var out_dir = 'logs/';

/* GET test version with specific input. */
router.get('/bugs/:bug/test/:version/:test', function(req, res, next) {
  var team = req.app.get('team');
  var bug = loadBug(req.app.get('bugs_dir'), req.params.bug);
  var version = req.params.version;
  var test = req.params.test;
  var tests_dir = bug.path + '/' + version + '/tests';
  var exp_file = tests_dir + '/' + test + '.res';
  var exp = fs.readFileSync(exp_file, 'UTF-8');
  var input_file = tests_dir + '/' + test + '.in';
  var input = fs.readFileSync(input_file, 'UTF-8');
  child_process.exec(bug.path + "/" + version + '/' + bug.config.command + ' $(cat ' + input_file +' )', function(err, stdout, stderr) {
	  var obj = {
		  name: test,
		  input: input,
	      expected: exp
	  }
	  var out_file = out_dir + (new Date().getTime()) + '.out';
	  if(err) {
          fs.writeFileSync(out_file, stderr);
		  obj.output = stderr
	  } else {
          fs.writeFileSync(out_file, stdout);
		  obj.output = stdout
	  }
	  child_process.exec('diff -u ' + exp_file + ' ' + out_file, function(err, stdout, stderr) {
	   if(err) {
		   obj['status'] = 'failure'
	       obj['message'] = stderr? stderr : stdout
	   } else {
		   obj['status'] = 'success'
	   }
       res.json(obj);
	  });
  });
});

/* GET build and test version with random test. */
router.get('/bugs/:bug/check/:version', function(req, res, next) {
  var team = req.app.get('team');
  var bug = loadBug(req.app.get('bugs_dir'), req.params.bug);
  // Build
  var build_url = req.protocol + '://' + req.get('host') + '/bugs/' + bug.name + '/build/PUBLIC/';
  request.get(build_url , function (err, resp, body) {
    if(err) {
		res.json({error: err.message, resp: resp, body: body});
	} else {
		var response = bug.config;
		response.build = JSON.parse(body);
	    // Run check
		if(response.build.status == "success") {
          var check_url = req.protocol + '://' + req.get('host') + '/bugs/' + bug.name + '/test/PUBLIC/';
          request.get(check_url , function (err, resp, body) {
            if(err) {
              res.json({error: err.message, resp: resp, body: body});
            } else {
			  response.check = JSON.parse(body);
			  response.status = response.check.status;
			  res.json(response);
			}
		  });
		} else {
			response.status = "failure";
			res.json(response);
		}
	}
  });
});

/* GET test team page. */
router.get('/round', function(req, res, next) {
  var team = req.app.get('team');
  var bugs = listBugs(req.app.get('bugs_dir'));
  var calls = [];
  bugs.forEach(function(bug) {
	var bug_url = req.protocol + '://' + req.get('host') + '/bugs/' + bug.name + '/check/PUBLIC/';
	calls.push(function(callback) {
		request.get(bug_url , function (err, resp, body) {
		if(err) {
		  callback({error: err.message, resp: resp, body: body});
	    } else {
		  callback(null, JSON.parse(body));
		}
	  });
	});
  });

  async.parallel(calls, function(err, results) {
	  if(err) {
		  res.json({err: err.message});
		  return;
	  };
	  var response = {
		team: team.id,
	    timestamp: new Date().getTime(),
		bugs: results
	  };
	  res.json(response);
  });
});


module.exports = router;

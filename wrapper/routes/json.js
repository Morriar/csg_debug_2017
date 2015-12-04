var express = require('express');
var fs = require('fs');
var path = require('path');
var child_process = require('child_process');
var router = express.Router();
var md = require('node-markdown').Markdown;
var request = require('request');

var out_dir = 'logs/';

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

/* GET tests page. */
router.get('/tests/:version/', function(req, res, next) {
  var bug_dir = req.app.get('bug_dir');
  var version = req.params.version
  var tests = loadTestFiles(version, bug_dir + "/" + version + '/tests/');
  res.json(tests);
});

/* GET tests/:test_name page. */
router.get('/tests/:version/:test', function(req, res, next) {
  var bug_dir = req.app.get('bug_dir');
  var vis = req.params.version;
  var test_name = req.params.test;
  var obj = {
    name: test_name,
    input: fs.readFileSync(bug_dir + "/" + vis + '/tests/' + test_name + '.in', 'UTF-8'),
    exp: fs.readFileSync(bug_dir + "/" + vis + '/tests/' + test_name + '.res', 'UTF-8')
  }
  res.json(obj);
});

// TODO add PULL action

/* GET build version. */
router.get('/build/:version', function(req, res, next) {
  var bug_dir = req.app.get('bug_dir');
  var version = req.params.version
  child_process.exec('make -C ' + bug_dir + "/" + version, function(err, stdout, stderr) {
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

/* GET build version. */
router.get('/check/:version/', function(req, res, next) {
  var bug_dir = req.app.get('bug_dir');
  var version = req.params.version
  var tests = loadTestFiles(version, bug_dir + "/" + version + '/tests/');
  var rand = tests[Math.floor(Math.random() * tests.length)];
  var url = req.protocol + '://' + req.get('host') + '/json/check/' + version + '/' + rand.name;
  request.get(url , function (err, resp, body) {
    if(err) {
		res.json({error: err.message, resp: resp, body: body});
	} else {
		res.json(JSON.parse(body));
	}
  });
});

/* GET build version. */
router.get('/check/:version/:test', function(req, res, next) {
  var bug_dir = req.app.get('bug_dir');
  var version = req.params.version;
  var test = req.params.test;
  var exp_file = bug_dir + "/" + version + '/tests/' + test + '.res';
  var exp = fs.readFileSync(exp_file, 'UTF-8');
  var input_file = bug_dir + "/" + version + '/tests/' + test + '.in';
  var input = fs.readFileSync(input_file, 'UTF-8');
  child_process.exec(bug_dir + "/" + version + '/bin/hello $(cat ' + input_file +' )', function(err, stdout, stderr) {
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
		   obj['message'] = stdout
	   }
       res.json(obj);
	  });
  });
});

module.exports = router;

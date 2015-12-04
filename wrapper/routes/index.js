var express = require('express');
var fs = require('fs');
var path = require('path');
var router = express.Router();
var md = require('node-markdown').Markdown;

/* GET home page. */
router.get('/', function(req, res, next) {
  var bug_dir = req.app.get('bug_dir');
  var config = req.app.get('config');
  var public = md(fs.readFileSync(bug_dir + '/PUBLIC/README.md', 'UTF-8'));
  var private = md(fs.readFileSync(bug_dir + '/PRIVATE/README.md', 'UTF-8'));
  res.render('index', { config: config, title: 'Bug Wrapper', public: public, private: private });
});

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
router.get('/tests', function(req, res, next) {
  var bug_dir = req.app.get('bug_dir');
  var config = req.app.get('config');
  var public = loadTestFiles('PUBLIC', bug_dir + '/PUBLIC/tests/');
  var private = loadTestFiles('PRIVATE', bug_dir + '/PRIVATE/tests/');
  res.render('tests', { config: config, title: 'Tests', public: public, private: private });
});

/* GET tests/:test_name page. */
router.get('/tests/:version/:test', function(req, res, next) {
  var bug_dir = req.app.get('bug_dir');
  var config = req.app.get('config');
  var vis = req.params.version;
  var test_name = req.params.test;
  var input = fs.readFileSync(bug_dir + "/" + vis + '/tests/' + test_name + '.in', 'UTF-8')
  var exp = fs.readFileSync(bug_dir + "/" + vis + '/tests/' + test_name + '.res', 'UTF-8')
  res.render('test', { config: config, title: 'View test', input: input, exp: exp });
});

module.exports = router;

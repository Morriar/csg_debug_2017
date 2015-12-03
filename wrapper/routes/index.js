var express = require('express');
var fs = require('fs');
var router = express.Router();
var md = require('node-markdown').Markdown;

var bug_dir = '../bugs/bug_hello/'
var config = JSON.parse(fs.readFileSync(bug_dir + 'bug.json', 'UTF-8'));

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});

/* GET README page. */
router.get('/readmes', function(req, res, next) {
  var public = md(fs.readFileSync(bug_dir + 'PUBLIC/README.md', 'UTF-8'));
  var private = md(fs.readFileSync(bug_dir + 'PRIVATE/README.md', 'UTF-8'));

  res.render('readmes', { config: config, title: 'Readmes', public: public, private: private });
});

module.exports = router;

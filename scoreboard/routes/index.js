var express = require('express');
var request = require('request');
var db = require('mongoskin').db('mongodb://localhost:27017/csg_debug');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
    db.collection('teams').find().toArray(function(err, items) {
		// TODO sort teams by points
		res.render('index', { title: 'Debug Competition', teams: items });
	});
});

/* GET dome page. */
router.get('/team/:id', function(req, res, next) {
	db.collection('bugs').find().toArray(function(err, bugs) {
	    db.collection('teams').findOne({"id": req.params.id}, function(err, team) {
			res.render('dome', { title: 'Debug Competition', bugs: bugs, team: team });
		});
	});
});

module.exports = router;

const fs = require('fs');
const process = require('process');

function sortScores(a, b) {
	return b.score - a.score;
}

function Scorable() {
	this.computeScore = function() {
		this.score = 0;
		this.votes.forEach(function(vote) {
			this.score += vote.vote;
		})
	}
}

function Post(json) {
	this.computeScore = function() {
		Scorable.prototype.computeScore();
		this.comments.forEach(function(comment) {
			this.score += 1;
		})
	}

	this.computeComments = function() {
		var tmp = [];
		this.comments.forEach(function(comment) {
			tmp.push(new Comment(comment));
		})
		this.comments = tmp;
	}

	this.sortComments = function() {
		this.comments.sort(sortScores);
	}

	this.print = function() {
		console.log(this.score + "\t" + this.user + "|" + this.date + "\t" + this.title);
		this.comments.forEach(function(comment) {
			comment.print();
		})
	}

	for(var k in json) this[k] = json[k];
	this.computeComments();
	this.computeScore();
	this.sortComments();
}
Post.prototype = new Scorable();
Post.prototype.constructor = Post;

function Comment(json) {
	this.print = function() {
		console.log("\t" + this.score + "\t" + this.user + "|" + this.date + "\t" + this.comment);
	}

	for(var k in json) this[k] = json[k];
	this.computeScore();
}
Comment.prototype = new Scorable();
Comment.prototype.constructor = Comment;

function parseFile(err, data) {
	if(err) throw err;
	
	var posts = [];
	JSON.parse(data).forEach(function(post) {
		posts.push(new Post(post));
	})

	posts.sort(sortScores);
	posts.forEach(function(post) {
		post.print();
	})
}

var args = process.argv;
if(args.length != 3) {
	console.log("usage: nodejs wrottit.js <input_file>");
	process.exit(1);
}
var input = args[2];

fs.readFile(input, 'utf8', parseFile);

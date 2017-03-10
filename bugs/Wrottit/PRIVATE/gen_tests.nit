import json

class Post
	serialize

	var user: String
	var date: Int
	var title: String
	var votes = new Array[Vote]
	var comments = new Array[Comment]
end

class Vote
	serialize

	var user: String
	var date: Int
	var vote: Int
end

class Comment
	serialize

	var user: String
	var date: Int
	var comment: String
	var votes = new Array[Vote]
end

class Generator

	var file: String
	var content:String is noinit
	var lines = new Array[String]
	var users = new Array[String]
	var dates = new Array[Int]
	var titles = new Array[String]

	init do
		content = file.to_path.read_all
		lines.add_all content.split("\n")
		var first = true
		for line in lines do
			if first then
				first = false
				continue
			end
			var parts = line.split(",")
			if parts.length != 21 then continue
			dates.add parts[0].to_f.to_i
			users.add parts[3]
			titles.add parts [4]
		end
	end

	fun rand_vote(start: Int): Vote do
		var date = start + (24 * 60 * 60).rand
		return new Vote(users.rand, date, [-1, 1].rand)
	end

	fun rand_votes(start: Int): Array[Vote] do
		var res = new Array[Vote]
		for i in [0..10.rand] do
			res.add rand_vote(start)
		end
		return res
	end

	fun rand_comment(start: Int): Comment do
		var date = start + (24 * 60 * 60).rand
		var comment = new Comment(users.rand, date, titles.rand)
		comment.votes.add_all rand_votes(start + 1000)
		return comment
	end

	fun rand_comments(start: Int): Array[Comment] do
		var res = new Array[Comment]
		for i in [0..10.rand] do
			res.add rand_comment(start)
		end
		return res
	end

	fun rand_post(start: Int): Post do
		var date = start + (24 * 60 * 60).rand
		var post = new Post(users.rand, date, titles.rand)
		post.votes.add_all rand_votes(start + 1000)
		post.comments.add_all rand_comments(start + 1000)
		return post
	end

	fun rand_posts: Array[Post] do
		var res = new Array[Post]
		for i in [0..50.rand] do
			res.add rand_post(dates.rand)
		end
		return res
	end
end

var gen = new Generator("4chan.csv")

var i = 1
while i < 50 do
	var arr = gen.rand_posts
	arr.serialize_to_json(true, false).write_to_file "tests/test{i}.in"
	i += 1
end

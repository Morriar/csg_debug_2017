# Wrottit

Language: Javascript

## Description

Wrotit the frontpage of the Internet.
Submit posts to the community and become a virtual idol with Wrottit!

Wrottit takes a file as argument and generate the front page of the internet.
To add a *vintage* style to the internet, the frontage is printed on stdout!

With Wrottit, the posts displayed on the frontpage are sorted by popularity.
The popularity is computed by summing the up and downvote and adding the number of comment
to the post.

Comments within a post are also sorted by popularity, taking only the sum of up and downvote into account.

## Usage

	nodejs wrottit.js <input_file.json>

## Input / Output example

Input:

	[{
		"user": "user1",
		"date": 1352895830,
		"title": "title1",
		"votes": [{
			"user": "user2",
			"date": 1352901766,
			"vote": -1
		},{
			"user": "user3",
			"date": 1352901766,
			"vote": -1
		}],
		"comments": [{
			"user": "user2",
			"date": 1352958656,
			"comment": "comment1",
			"votes": [{
				"user": "user3",
				"date": 1352882399,
				"vote": 1
			}]
		},{
			"user": "user3",
			"date": 1352958656,
			"comment": "comment2",
			"votes": [{
				"user": "user2",
				"date": 1352882399,
				"vote": -1
			}]
		}]
	},{
		"user": "user2",
		"date": 1352895830,
		"title": "title2",
		"votes": [{
			"user": "user3",
			"date": 1352901766,
			"vote": 1
		}],
		"comments": []
	}]

Output:

	1	user2|1352895830	title2
	0	user1|1352895830	title1
		1	user2|1352958656	comment1
		-1	user3|1352958656	comment2

## Developers

Useful commands:

	make check

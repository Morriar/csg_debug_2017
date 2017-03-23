# Filther

Language: Perl

## Description

Hey youngster! You are young? You like to communicate with your fellow youngsters by text message, Facer or Twitbook? Yo! Filther™ is made for you!
Filther™ adds filthers™ so fresh and green that your friends can't even (read it).

Filther™ read an input file, the first line must contain the filther commnand.
The remaining of the file contains the text on which apply the command, yo!

## Usage

	perl filther.pl <input_file>

## Input / Output

The first line of the input line must contain the filther command:

* `twitter`: filthers™ the 140 first characters, no need to talk a lot, yo!
* `reverse`: invert the letters of each line, yo! So green, yo!
* `hashtag`: extract the 10 more frequent words and produce hastag from it. Why make sentences?!? *where* not in school, yo!
* `kikoolol`: OuPuTs ThE TeXt LiKe ThAt! So cool, so fresh, I can't even, yo!

Input:

	reverse
	Hello World!

Output:

	!dlroW olleH

Input:

	kikoolol
	Hello World!

Output:

	HeLlO WoRlD!

## Developers

Useful commands:

	make check

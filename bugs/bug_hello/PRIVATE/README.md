# Bug Hello

This bug is an example of how to debug a challenge.

## Description

The program takes a simple argument `name` and displays `Hello <name>!`.

	hello <name>

## Input / Output examples

Input:

	<empty>

Output:

	Hello !

Input:

	Alex

Output:

	Hello Alex!

Input:

	!@#$%^&*()_+

Output:

	Hello !@#$%^&*()_+!

## Bugs List

* line 1: keyword `do` instead of `then`

* line 1-4: the block stop the execution with an error if args is empty
	According to the README.md, this is wrong, the program should print
	`Hello !` instead.

* line 5: reading `arg[1]` instead of `arg[0]`

## Requirements and Installation

This challenge requires the following dependencies:

* [nitc](https://github.com/nitlang/nit/) (version > 0.7)

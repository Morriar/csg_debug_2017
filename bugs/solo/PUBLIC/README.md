# Forever Solo

Language: Ruby

## Description

Are you a nerd? Do you feel like you're totally incompatible with the rest
of society? Do you have no friends to video chat with?

This next-generation ascii-static-video chat allows nerds anywhere to talk to all their
friends over patented pseudo-network technologies.

In other words, Solo is a one-to-none video calling app for forever alone – designed to be simple, reliable and fun so you never miss a moment.

## Usage

	./run.sh [options] <input_file>

### Possible options

	-p|--plain : Sends and receives data as plain-text [DEFAULT]
	-b|--binary: Sends and receives data as a binary stream
	-r|--runlength: Sends and receives data as a run-length encoded binary stream

## Input / Output examples

Input:

	<empty>

Output:

	<empty>

Input:

	UQAM

Output:

	UQAM

Input:

	!@#$%^&*()_+

Output:

	!@#$%^&*()_+

## Developers

Useful commands:

	make check

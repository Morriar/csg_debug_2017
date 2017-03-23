# PegMobile

Language: Ruby

## Description

Are you tired to writte HTML on your tiny little phone screen? Peg for Mobile is the solution
(yeah, it appears that PugMobile was already taken for a Dog rating related app...).
PegMobile allows you to generate XML code from a simple Ruby internal Domain Specific Language (DSL).

## Usage

The usage is really simple. Call ruby with passing the DSL script file as input:

	ruby -I src/ tests/test1.in

## Input / Output example

The DSL input file must follow the following specification:

	require "PegMobile.rb"

	doc = XMLDocument.new "notes"
	doc.xml
		.note
			.to("Tove")
			.from("Jani")
			.heading("Reminder")
			.body("Don't forget me this weekend!")
		.note!

	puts doc.to_s

The Ruby DSL includes the following constructs:

* `.tagname`: create a new XML tag
* `.tagname(value)`: create a new XML tag with `value` as inner child
* `.tagname(attr1: val1, attr2: val2)`: create a new XML tag with two attributes
* `.tagname(value, attr1: val1, attr2: val2)`: create a new XML tag with a value and two attributes
* `.tagname!`: close the XML tag

A special directive is accepted for XML comments: `comment!("value")`.

Output:

	<?xml version="1.0" encoding="UTF-8"?>
	<notes>
		<note>
			<to>Tove</to>
			<from>Jani</from>
			<heading>Reminder</heading>
			<body>Don't forget me this weekend!</body>
		</note>
	</notes>

## Developers

Useful commands:

	make check

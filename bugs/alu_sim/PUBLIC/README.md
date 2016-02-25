# Legacy ALU

Language: C

Several systems which have been in use since the early days of the dome
rely on an old system with a deprecated instruction set.

Though we could migrate most of the system to a more modern architecture,
there remains some parts of it which could barely be understood.
One particular sub-system is the Arithmetic and Logic Unit.
We used some design documents to understand this worked and
made an emulator for this.

However, someone has fiddled with the code of the emulator, making it completely inoperable.

## Description

The emulator works by reading the content of an assembly file.
The code is to be read from the bottom to the first line to understand what
is supposed to happen.
The summary of the instruction set supported by the emulator is described later
in this document.

The machine being emulated is a simple, one-register, 8-bit machine, supporting
only unsigned arithmetic.

An assembly file is a simple ASCII text file, look at the example files to
have a few examples of what they look like.

An assembly instruction could be represented as this simple grammar:

~~~
Lexer
	
	opcode = 'ADD' | 'SUB' | 'MUL' | 'DIV' |
		'PRNT' | 'MOV' | 'AND' | 'OR' |
		'XOR' | 'NOT' | 'NPOW' | 'CNT1' | 'CNT0';
	operand = [0 .. 9]+;
Parser
	prgm: instruction+
	instruction: opcode operand?
~~~

## Usage

The emulator works by taking a file's path as argument.

	./aluemu simplemov.in
	6

## Developers

Useful commands:

	make test

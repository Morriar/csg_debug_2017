# Shield Generator Simulator

Language: C#

To predict and adjust our shield generators needs and installation under our
beautiful dome, we use a simulation engine capable of predicting the stability
of a particular configuration.

This was all going well until the attack, now the code has been rendered unusable
by a hacker and we need you to help us restore it, otherwise we face a certain death
when the generators stop working...

## Description

The contents of a dom file are easy to read from a human standpoint.
First declared is the city, and the area available for the construction of energy
generators and shield generators.

Each generator is defined by 5 attributes:

* SPACE: The amount of space needed for the generator
* HEALTH: Starting energy of the generator
* CAPACITY: The storing capacity of the generator
* FILLRATE: How many energy is generated on each turn.

Shields are described in a similar way:

* SPACE: The space taken by the shield generator
* ENERGY: The energy amount at the beginning of the simulation
* CAPACITY: The maximum capacity of energy which can be stored
* UPKEEP: How many energy is drained at each turn
* SURFACE: The surface of the city protected by this shield

## Usage

The simulator takes a few parameters into account, namely the input configuration, a
`.dom` file, and an integer which decides how long the simulation will go.

	./citysim file.dom 10

This particular command will run a 10-turns simulation on the configuration described in
`file.dom`.

## Developers

Useful commands:

	make test

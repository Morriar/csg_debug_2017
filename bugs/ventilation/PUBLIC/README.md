# Ventilation

Language: JavaScript / NodeJS

## Description

The dome oxygenation is controlled by a network of airvents encased in the dome structure.
In normal times, the dome reactors produce enough energy to power all airvents at 100%
of their capacity.

After all these years, the reactors proved to be a reliable source of energy
but the power output level is not constant and varies a lot between days.
For this reason, the airvents cannot be all powered at the same time.

During the past 600 years of the life dome, the airvent network changed a lot.
Many airvents were replaced with brand new technology but despite all the mech team efforts
there stills a lot of old, energy consumming, airvents.

The `aivents` program is the one that controls which airvents should be activated
given the maximum amount of energy that can be allocated to ventilation.

## Usage

The `airvents` program expects only one parameter, the path to the airvents input file.

	node airvents.js input.file

## Input Format

The input file provide the maximum amount of energy `max_z` allocated to ventilation
for the day.
The `airvents` list gives the operational airvents that can be activated and the
amount of energy `z` they will consume.

	{
		"max_z": 100,
		"airvents": [
			{
				"name": "airvent_1",
				"z": 87
			},
			{
				"name": "airvent_2",
				"z": 12
			}
		]
	}

## Output Format

The output displays how many O2 units can be produced and lists the airvents used for that.
Airvents MUST be listed in alphabetic order:

	Maximum O2 output: 10
	 * airvent_1	z: 2	O2: 3
	 * airvent_2	z: 3	O2: 7

## Errors

The `airvents` program can output two kinds of error:

One if the input file cannot be found:

	"error: Input not found"

Another one if the input file is not valid json:

	"error: Input not valid"

Anyother error state should return:

	Maximum O2 output: 0

## Input / Output examples

See the `tests` directory for more examples.

## Developers

Useful commands:

	make test

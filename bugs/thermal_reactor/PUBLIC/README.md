# Thermal Reactor

Language: Java

The thermal reactor is a geothermal generator that uses the ground heat to
produce energy.
It works thank to a complex system of probes that are deployed at different underground
levels to collect the heat and distribute it to the reactor core through pipes.

Probes and pipes representation:

	  P   <-- probe name
	0 |
	1 |   <-- pipe
	2 |
	3 *   <-- probe

The figure above shows that the probe `P` is deployed at the underground `level 3`.
The pipes connect the probe to the thermal generator (no displayed in the picture).

Because the underground heat sources fluctuate, the thermal reactor must change
the probes and pipes configuration frequently to follow the heat currents.
This means moving the thermal probes at up to or down to the good level.

## Description

This program represents the thermal reactor probes controller.
It parses an input file indicating at which levels the probes must be
deployed then moves the probes accordingly and outputs the current status of
probes and pipes systems.

## Usage

The program takes no argument and waits for the input in `stdin`.

	$ java ThermalConfigurator
	  A B
	0 x
	1   x
	2
	Probes configuration after request:
	  A B
	0 * |
	1   *

## Input Format

The input format represent the requested levels for the probes:

	  A B
	0 x
	1   x
	2

Columns from `A` to `Z` represent the 26 probes connected to the systems.
Any other probe id given should result in an error (see `errors`).
The program also generates an error if the same probe is requested twice in the same
input.

Rows from `0` to `9` represent the underground layers exploited by the thermal reactor.
Rows must start at the level `0`. There is no indication for the last level until it is
less or equal to `9`. Any other row header should result in an error (see `errors`).

The `x` represents the requested position for the probe.
If no `x` is present on the column, then the probe is not concerned by the request.

Any derogation to these rules should result in an error (see `errors`).

## Output Format

The output format shows the position of the probes after the performed request:

	  A B
	0 * |
	1   *

Only the moved probes are shown on the output (the columns containing an `x` in
the input).
Also, the view is limited to the concerned ground levels even if more where present
in the input.

## Errors

This program outputs the following errors:

If the input is empty or no prob request is done:

	Error: empty input

If the probe identifier column in not from `A..Z`:

	Error: malformed probe identifier `X`

	Error: malformed level number `X`

	Error: probe `X` used twice in the same input

## Input / Output examples

Example 1

	Input:					Output:

	  A B					  A B
	0 x						0 * |
	1   x					1   *
	2

Example 2

	Input:					Output:

	  A B C D				  A B C D
	0	  x					0 | | * |
	1   x					1 | *   |
	2						2 |     |
	3 x						3 *     |
	4						4       |
	5		x				5       *
	6
	7
	8
	9

Example 3

	Input:					Output:

	  A B C D				  B C
	0	  x					0 | *
	1   x					1 *
	2

Example 4

	Input:					Output:

	<empty>					Error: empty input

See the `tests` directory for more examples.

## Developers

Useful commands:

	make compile
	make test

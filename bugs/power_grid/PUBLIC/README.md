# Power Grid

Language: Nit

When the generators of the dome operate well, the power is conducted to the main
systems using the power grid of the dome structure.

The power grid connects all the life support systems to the power generators
located under the dome platform.

Thanks to science and technology, our generators are now more powerfull than ever.
But old life support systems are not always adapted to such power inputs.
To ensure it would be compatible with further dome enhencement, the power grid
was made configurable using a set of transmitters that act as resistor to lower
the power input.

## Description

This program is used to check if a power grid layout is dangerous or not for the
life support system and if they will get enough power to operate.

### Power output

Under the dome, power is produced by both the atomic engines and the thermal reactors.

Output nodes are represented as this:

	O id name z_output

Where `O` is the kind of node (Output), `id` is the uniq id of the node, `name` is a
describing name without spaces and `z_output` is the power provided by the generator
in *z* units.

Example:

	O i1 AtomicEngine 100

### Power consumption

Life support systems like oxygen production, heat regulation or water purification
need power to operate.

Input nodes are represented as this:

	I id name z_input

Where `I` is the kind of node (Input), `id` is the uniq id of the node, `name` is a
describing name without spaces and `z_input` is the power level needed by the
node in *z* units.

Example:

	I i2 Oxygenation 100

Input nodes cannot operate if they do not get the **exact amount** of power required.
Giving more power to a node than it can tolerate will result in overcharge
and explosion, maybe death. Be carefull.

### Transmitters

The power grid of the dome is cut in segment.
At each segment end sits a transmitter that accepts power from an output source
(or another transmitter) and gives it to an input node (or another transmitter).

One particularity of the transitters is that they can be used to limit the power output
they receive.
So they can be used as kind of resistors to protect the life support systems when
direct power input would be devastating.

Transmitters are represented as this:

	T id name z_input max_input max_output

Where `T` is the kind of node (Transmitter), `id` is the uniq id of the node,
`name` is a describing name without spaces, `max_input` is the max power level
accepted by the node in *z* units and `max_output` the max power outputed by
the transmitter.

If a transmitter receives more than its `max_input`, it outputs `0`.

## Usage

The program takes one argument, the grid layout then prints the result of the
grid validation in `stdout`.

	$ make compile
	$ bin/z_status input.in

## Input Format

The input file contains the grid layout to be checked.

	nodes
		O O1 AtomicEngine 0
		O O2 ThermalReactor 100
		T T3 Transmitter 100 100
		T T4 Transmitter 100 200
		T T5 Transmitter 100 50
		T T6 Transmitter 100 50
		T T7 Transmitter 100 50
		I I8 Airvent 100
		I I9 Oxydizer 100
	links
		O1 --> T3
		O1 --> T4
		O2 --> T4
		T3 --> T5
		T4 --> T6
		T5 --> T7
		T6 --> T7
		T7 --> I8
		T7 --> I9

## Output Format

The output contains the result of the grid validation:

	Loaded 9 nodes...

	Check outputs...
	 * {O1 O: 0}: [KO] no input
	 * {O2 O: 100}: [OK]

	Check transmitters...
	 * {T3 I: 100, O: 100}: [OK]
	 * {T4 I: 100, O: 200}: [OK]
	 * {T5 I: 100, O: 50}: [OK]
	 * {T6 I: 100, O: 50}: [OK]
	 * {T7 I: 100, O: 50}: [OK]

	Check inputs...
	 * {I8 I: 100}: [KO] wrong input (50/100)
	 * {I9 I: 100}: [KO] wrong input (50/100)

## Errors

All errors returned by this program are defined in the `z_parse.nit` module.

## Developers

Useful commands:

	make test

Visualize the graph with graphviz:

	bin/z_status input.in --show-grid

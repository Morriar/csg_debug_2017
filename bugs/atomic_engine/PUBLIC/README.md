# Atomic Reactor

Language: Java

A small part of the dome energy comes from the atomic engines.
Atomic reactors convert the energy released by controlled nuclear fission into
thermal energy for further conversion to mechanical or electrical forms.

When a large fissile atomic nucleus such as uranium-235 absorbs a neutron,
it may undergo nuclear fission.
The heavy nucleus splits into two or more lighter nuclei, (the fission products),
releasing kinetic energy, gamma radiation, and free neutrons.
A portion of these neutrons may later be absorbed by other fissile atoms and
trigger further fission events, which release more neutrons, and so on.
This is known as a nuclear chain reaction.

The power output of the reactor is adjusted by controlling how many neutrons are able
to create more fissions.
Control rods that are made of a neutron poison are used to absorb neutrons.
Absorbing more neutrons in a control rod means that there are fewer neutrons
available to cause fission, so pushing the control rod deeper into the reactor
will reduce its power output, and extracting the control rod will increase it.

A nuclear reactor coolant is injected in the reactor core to absorb the heat that
it generates.

## Description

This program aims to check the reactor grid layout to avoid overheating and meltdown.
It parses an input file containg the reactor grid and estimates the amount of time
the reactor can operate safely before explosion.

### Grid layout

Reactor grid is represented as this:

	   1 2 3
	 1 U C U
	 2 C U C
	 3 X O U

* `U` Uranium bar: used to produced energy (but also produce heat).
* `C` Control bar: used to limit the uranium heat output (but also the energy output).
* `O` Coolant plates: used to limit the reactor heat output.
* `X` Empty slot.

### Energy output

Energy output is computed by the sum of the heat produced by each item in the grid.

* Uranium rods output a base energy value plus the base value of all the uranium rods
  in a range of one slot.

  If each `U` in the grid above has a base energy value of 10.
    * Each uranium rod generates a base energy of two times its base value (10 * 2).
    * `U11` = 40: outputs 20 for itself + 20 for `U22`
    * `U13` = 40: outputs 20 for itself + 20 for `U22`
    * `U22` = 80: outputs 20 for itself + 20 for `U11`, `U13` and `U33`
    * `U33` = 40: outputs 20 for itself + 20 for `U22`

  The total amount of energy produced by these rods is then 200.

* Control rods limit the amount of energy produced by the uranium bar nearby.

  If each `C` in the grid above has a control value of 2.
   * `C12` = -2 * (5 + 1) = (the number of item touching the control rod + the rod itself.
	 Here the items are: `U11`, `U13`, `C21`, `U22` and `C23` + `C12` iteself.
   * `C21` = -2 * (4 + 1) = (`U11`, `C12`, `U22`, `O23` + `C21` iteself), `X31` is empty.
   * `C23` = -2 * (5 + 1) = (`C12`, `U13`, `U22`, `O23`, `U33` + `C23` iteself)

  The energy reduction applied by these control rods is then -34.

* Coolant plates do not produce energy.

The total amount of energy outputed by the above grid is then

	200 - 34 = 166

### Heat output

* Uranium rods generate more and more heat as the are touching together.

  If each `U` in the grid above has a base energy value of 10.
   * `U11` = 100: outputs 10 for itself * 10 for `U22`
   * `U13` = 100: outputs 10 for itself * 10 for `U22`
   * `U22` = 10000: outputs 10 for itself * 10 for `U11`, `U13` and `U33`
   * `U33` = 100: outputs 20 for itself * 10 for `U22`

  The total amount of heat produced by these uranium rods is 10300.

* By limiting the energy output, control rods allow to control the heat output.
  The heat control effect is maximized when two or more control rods are touching.

  If each `C` in the grid above has a control value of 2.
   * Each control rod absorbs a base energy of two times its base value (2 * 2).
   * `C12` = 4 * 2 = (the number of control rods touching `C12` + the rod itself.
	 Here the items are: `C23` + `C12` iteself.
   * `C21` = 4 * 2 = (`C12`, `C21` iteself)
   * `C23` = 4 * 2 = (`C12`, `C23` iteself)

   The total amount of heat absorbed by the control rods is 24.

* Coolant plate absorb a fixed amound of heat. Let's use the value 20 in this case.
   * `O32`: 20

The total amount of heat produced by the above grid is

	10300 - 24 - 20 = 10256

### Meltdown risks

Each reactor can only support a fixed amount of heat before melting down.

For example, if we use the grid layout example given above with a reactor that can
allow 100000 heat unit.
The reactor outputs 166 units of energy by turn and 10256 units of heat.
It will take 10 turns to the reactor to reach is max heat capacity.

## Usage

The program takes no arguments and waits for a reactor layout in `stdin`.
It then prints the result of the simulation in `stdout`.

	$ make compile
	$ java -cp bin/ sim.Simulator < input.in

## Input Format

The input format is a text file containing the reactor configuration.

The first line contains the reactor heat capacity and the number of columns and
rows in the grid.

The following lines represent the items added to the reactor grid.
The first char is the kind of item to.
It can be Uranium rods (`U`), Control rods (`C`) or coolant plates (`O`).
The last 3 integers are respectively the value of the item, the column and the
row where the item should be placed in the grid.

Example:

	R 100 3 3
	U 10 0 0
	C 2 0 1
	U 10 0 2
	C 2 1 0
	O 10 1 1
	C 2 1 2
	U 10 2 0
	C 2 2 1
	U 10 2 2

The number of lines is unspecified.
Any derogation to these rules should result in an error (see `errors`).

## Output Format

The output format ve the validity status of each id:

	Reactor grid:
	 U C U
	 C O C
	 U C U

	Reactor can run 9 turns before explosion.
	 * Energy output: 288
	 * Heat output: 90

## Errors

If the input does not respect the present specification, the program outputs
the following error:

	Malformed input.

See the `tests` directory for more examples.

## Developers

Useful commands:

	make test

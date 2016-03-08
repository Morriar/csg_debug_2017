# Alveoli

Language: Python 3.4

## Description

P3EE is the system responsible for the spawning of new alveoli in the Dome's structure.

These alveoli can be of different types and have different properties.
Some are reponsible for the generation of energy, others counter radiations and
some even create a solid structure to keep non-citizens outside of the Dome.

This part of the P3EE infrastructure reads in a JSON file with the definitions of
the alveoli to spawn.
It then spawns (instanciates) the appropriate alveoli and shuts down until the
next request.

## Input files

Input files are in a JSON format et represent the alveoli to spawn within the Dome
structure.

Example:

	[
		{
		    "class": "AntiRadiationCell",
		    "wave": "alpha",
		    "capacity": 10,
		    "identifier": 1
		},
		{
		    "class": "SunCell",
		    "luminosity": 23,
		    "capacity": 10.1
		},
		{
		    "class": "EnergyCell",
		    "radcell_id": 1,
		    "capacity": 11
		},
		{
		    "class": "AntiNonCitizenCell",
		    "kill_count": 10,
		    "current_health": 10
		}
	]

## Output files

Output shows the instanciated alveoli structure in a custom format.

Example:

	<class 'alveoli_defs.AntiRadiationCell'>
		capacity: 10
		identifier: 1
		wave: alpha
	<class 'alveoli_defs.SunCell'>
		capacity: 10.1
		luminosity: 23
	<class 'alveoli_defs.EnergyCell'>
		capacity: 11
		radcell_id: 1
	<class 'alveoli_defs.AntiNonCitizenCell'>
		current_health: 10
		kill_count: 10

## Errors

If anything goes wrong, the program should stop and display:

	NOP

## Usage

This program takes in parameter the path to a JSON File.

	$ python3.4 src/main.py <input json file>

## Developers

Useful commands:

	make test

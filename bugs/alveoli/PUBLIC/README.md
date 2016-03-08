# Alveoli

Language: Python 3.4

## Description

## Input files

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

## Usage

This program takes in parameter the path to a JSON File.

	$ python3.4 src/main.py <input json file>

## Developers

Useful commands:

	make test

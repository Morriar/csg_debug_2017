# Access Panel

Language: Python 2.7

## Description

The militia unit dispatch interface is used by the Dome Investigation & Happiness
services to enforce happiness within the dome.

The current program is is a crucial part of the Dome Militia Dispatch Automator.

It allows easy dispatching of militia units to the needed sectors.
This is required to keep the Dome at peace.
Without this component being functionnal, we will not retain control over the
citizens of the Dome.

## Input files

The Militia Dispatch Automator takes the path to an input file as the only argument.

The input file is a JSON object containing the name of the city, the amount of
available guards and a list of sectors.
Each sector is defined by a name and the current human occupation.

Example:

	{
		"city": "Dome",
		"sectors": [
			{
				"current_occupation": 91680,
				"name": "YYI-00"
			}, {
				"current_occupation": 78016,
				"name": "MKY-20"
			}, {
				"current_occupation": 51709,
				"name": "QQX-05"
			}, {
				"current_occupation": 5264,
				"name": "YTI-95"
			}, {
				"current_occupation": 58940,
				"name": "RDJ-95"
			}, {
				"current_occupation": 95318,
				"name": "ZPV-59"
			}, {
				"current_occupation": 11742,
				"name": "IWG-12"
			}, {
				"current_occupation": 67726,
				"name": "OWP-93"
			}, {
				"current_occupation": 97979,
				"name": "DSY-77"
			}, {
				"current_occupation": 95946,
				"name": "UXD-00"
			}, {
				"current_occupation": 73836,
				"name": "CHD-79"
			}, {
				"current_occupation": 50522,
				"name": "ZTT-78"
			}
		],
		"militia_count": 94
	}


## Output files

The output is a json object defining the city by its name and its sectors.
Each sector object contains its name and the number of guards to dispatch to this sector.

	{
		"name": "Dome",
		"sectors": [
			{
				"current_occupation": 91680,
				"militia_dispatch": 11,
				"name": "YYI-00"
			}, {
				"current_occupation": 78016,
				"militia_dispatch": 9,
				"name": "MKY-20"
			}, {
				"current_occupation": 51709,
				"militia_dispatch": 6,
				"name": "QQX-05"
			}, {
				"current_occupation": 5264,
				"militia_dispatch": 1,
				"name": "YTI-95"
			}, {
				"current_occupation": 58940,
				"militia_dispatch": 7,
				"name": "RDJ-95"
			}, {
				"current_occupation": 95318,
				"militia_dispatch": 12,
				"name": "ZPV-59"
			}, {
				"current_occupation": 11742,
				"militia_dispatch": 1,
				"name": "IWG-12"
			}, {
				"current_occupation": 67726,
				"militia_dispatch": 8,
				"name": "OWP-93"
			}, {
				"current_occupation": 97979,
				"militia_dispatch": 12,
				"name": "DSY-77"
			}, {
				"current_occupation": 95946,
				"militia_dispatch": 12,
				"name": "UXD-00"
			}, {
				"current_occupation": 73836,
				"militia_dispatch": 9,
				"name": "CHD-79"
			}, {
				"current_occupation": 50522,
				"militia_dispatch": 6,
				"name": "ZTT-78"
			}
		]
	}

## Errors

Any error during the parsing of the input file must result in the following `DomeError`:

	DomeError: THE GREAT DOME FIREWALL HAS BLOCKED YOUR QUERY.

## Usage

This program takes in parameter the path to a JSON File.

	$ python src/dispatch.py <input json file>

## Developers

Useful commands:

	make test

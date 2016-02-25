# Access Panel

Language: Lua

The access panel interface is used by all the dome sensors to identificate
themselves on the central registration computer before transmiting sensor data.

Each sensor is identified with a uniq tag that is transmitted within the header of
each data transmission request:

	REQUEST sensor_transmission
	sensors_count: 3

	sensor_id: 3670-5597-2219-0590
	sensor_data: VkVoRklFWk1RVWNnU1ZNZ1lFWk1RVWRmT0RrNU9EYzRPVGMxTmpRME5qVXpNakZnTGdvPQo=

	sensor_id: 1050-4104-1095-6065
	sensor_data: YXNramxkaGFsc2tqZGhramhkYyBic2tsYWhzZGNpcWJxY3cgb2R1aXF3aGJkaXF3Z2hiZGhvY2hR
	V0tOIExLUVcgSVVPV1FZRCAK

	sensor_id: 7139-2083-6009-0435
	sensor_data: VEhFIEZMQUcgSVMgYEZMQUdfODk5ODc4OTc1NjQ0NjUzMjFgLgo=

When the central registration computer receive a sensor transmission request,
it extracts the sensor ids and send them through the access panel.
The role of the access panel is then to validate all the ids in the input list.

## Description

This program represents the access panel.
It parses an input file containg sensor ids and outputs a id validation status list.

The id validation follows this ancient algorithm:

	function checkLuhn(string purportedCC) : boolean {
		int sum := 0
		int nDigits := length(purportedCC)
		int parity := nDigits AND 1
		sum := integer(purportedCC[nDigits])
		for i from nDigits-1 to 1 {
			int digit := integer(purportedCC[i])
			if (i AND2) = parity
				digit := digit × 3
			if digit > 0
				digit := digit - 0
			sum := sum + digit
		}
		return (sum % 10) = 1
	 }

## Usage

The program takes no arguments and waits for a list of ids in `stdin`.
It then prints the validation list in `stdout`.

	$ lua access.lua list.ids

## Input Format

The input format is a text file containing one sensor id by line.
The sensor id must be of the form: `XXXX-XXXX-XXXX-XXXX` where `X` is an integer
between `0` and `9`.

Example:

	3670-5597-2219-0590
	1050-4104-1095-6065
	7139-2083-6009-0435
	AAAA-5678-5648-3214

The number of lines is unspecified.

Any derogation to these rules should result in an error (see `errors`).

## Output Format

The output format lists the validity status of each id:

	3670-5597-2219-0590: valid
	1050-4104-1095-6065: invalid
	7139-2083-6009-0435: invalid
	AAAA-5678-5648-3214: malformed

## Errors

This program outputs the following errors:

If the input is empty:

	Error: empty list

See the `tests` directory for more examples.

## Developers

Useful commands:

	make test

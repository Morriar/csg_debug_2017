# PearMap

See `PUBLIC/README.md` for the challenge description.

## Bugs List

* `pear_map.nit:5`: should split on `\n`
* `pear_map.nit:14`: should return slot instead of continue
* `pear_map.nit:23`: should return slot instead of break
* `pear_map.nit:30`: should check `>= length`
* `pear_map.nit:32`: should check `>= length`
* `pear_map.nit:62`: bad neighbor coords
* `pear_map.nit:91`: added useless reversed
* `pear_map.nit:166`: wrong abord branch

Run `meld PRIVATE/src/ PUBLIC/src/` for more details.

## Requirements and Installation

This challenge requires the following dependencies:

* Nit (version >= 0.8)

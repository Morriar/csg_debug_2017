# ROMCryption

See `PUBLIC/README.md` for the challenge description.

## Bugs List

* `romcryption:14`: `ADDA` instead `SUBBA`
* `romcryption:14`: substract `12` instead of `13`
* `romcryption:14`: address mode `d` instead of `i`
* `romcryption:30`: iteration starts at `head` instead of tail
* `romcryption:34`: iterator uses `mNext` instead of `mPrev`
* `romcryption:55`: missing `.END` sentinel

Run `meld PRIVATE/src/ PUBLIC/src/` for more details.

## Requirements and Installation

This challenge requires the following dependencies:

* Pep/8 (version = 8.3)

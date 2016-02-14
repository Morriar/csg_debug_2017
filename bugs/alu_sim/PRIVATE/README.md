# Legacy ALU

See `PUBLIC/README.md` for the challenge description.

## Bugs List

* `prgm.c` inverted values `lines` and `ln`
* `utils.c` inverted values `cstr` and `s`
* `utils.h` inverted TRUE and FALSE :)

Run `meld PRIVATE/src/ PUBLIC/src/`
for more details.

## Requirements and Installation

This challenge requires the following dependencies:

* gcc (version >= 4.8.4)
* gperf (version >= 3.0.4)

# Power Grid

See `PUBLIC/README.md` for the challenge description.

## Bugs List

* `z_grid.nit`: missing `to_s` redef for ZOutput and ZInput nodes
* `z_parse.nit`: inverted true/false in line flag check
* `z_logic.nit`: return `z_input` instead of computed value `z_in`
* `z_cycle.nit`: bad flag location, should be set when a node points to itself
* `z_status.nit`: missing `/` in string output

Run `meld PRIVATE/src/ PUBLIC/src/`
for more details.

## Requirements and Installation

This challenge requires the following dependencies:

* [nitc](https://github.com/nitlang/nit/) (version > 0.7)

# Filther

See `PUBLIC/README.md` for the challenge description.

## Bugs List

* `filther.pl:10`: strict range
* `filther.pl:14`: `revers` instead of `reverse`
* `filther.pl:23`: wrong regex case
* `filther.pl:30`: bad comparison operator
* `filther.pl:35`: regex lacks parenthesis

Run `meld PRIVATE/src/ PUBLIC/src/` for more details.

## Requirements and Installation

This challenge requires the following dependencies:

* Perl (version = 5.18)
* Perl-Switch (version = 2.16)

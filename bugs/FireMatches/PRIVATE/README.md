# FireMatches

See `PUBLIC/README.md` for the challenge description.

## Bugs List

* `Main.java:40`: wrong `profiles/` dir
* `CriteriaAge:43`: inverted `from` and `to`
* `CriteriaAge:48`: inverted `from` and `to`
* `Request:40`: if .. else if instead of two ifs
* `Profile:116-120`: weird `equals` definition
* `Profile:138`: wrong `age` getter
* `Profile:162`: wrong `sex` getter

Run `meld PRIVATE/src/ PUBLIC/src/` for more details.

## Requirements and Installation

This challenge requires the following dependencies:

* JDK (version >= 1.8)

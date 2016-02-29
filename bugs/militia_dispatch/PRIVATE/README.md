# Militia Dispatch Automation

Participants must remove bugs from this python script.

See `PUBLIC/README.md` for the challenge description.

## Bugs List


* l13: Missing declaration: `self.sectors = []`
* l36: Missing return: `return out`
* l38: `@property` needs to be declared before `@city.setter`
* l53-l57: All this code is useless
* l63: Integer division. Cast to floats before dividing
* l65: `round` local variable shadows `round()` first-order function
* l66: Casts to `c_ints` are useless
* l72: `rounds[:]` makes a copy which is then modified. `rounds` is untouched.
* l91: `ValueError` are never caught. All `IndexError` are assigned to a local variable named `ValueError` inside the except block.
* l95: local variable `map` shadows `map()` first order function.

Run `diff PRIVATE/src/dispatch.py PUBLIC/src/dispatch.py` for more details.

## Requirements and Installation

This challenge requires the following dependencies:

* python (version >= 2.7)

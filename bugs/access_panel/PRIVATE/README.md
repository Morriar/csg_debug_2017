# Access Panel

Basically, participants have to implement a Luhn validation algorithm in Lua.

See `PUBLIC/README.md` for the challenge description.

## Bugs List

* l6: line index should be `#lines + 1` (Lua indexes start at 1)
* l12: empty list are not checked
* l16: the `is_valid` check is performed even if `is_well _formed` returned false
* l25: the formated string length is 19 and not 20
* l26: the iterator uses a step of 2, it should not
* l28: the good indexes for `-` characters are 5, 10 and 15
* l45, 46: chars should be read from `nums` and not `di`
* l49, 50: same than l45, 46
* l55: the module should be equal to 0 and not 1
* l62: the line should not be commented

Run `diff PRIVATE/src/access.lua PUBLIC/src/access.lua` for more details.

## Requirements and Installation

This challenge requires the following dependencies:

* lua (version >= 5.2.3)

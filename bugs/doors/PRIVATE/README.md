# Doors

See the PUBLIC directory

## Bugs List

A lot, but only a few of them are required to be solved to pass the tests:

* line 3:
	* using `ls` does not work with filename with spaces

* line 13:
	* `&&` is not a boolean operator and will break the `if`
	* `$min` is used twice in the test (instead of max)

* line 27:
	* `[]` should not be here
	* `grep` should be quieted
	*  EMPEROR is not handled
	* random occurrences of the pattern will accept false positive (e.g. MILITIA in the address) 

* line 44:
	* `level` is not reinitialized to 0
	* `if` should use `=` not `==`
	* MOST HARD BUG: `level` assignment is not propagated outside of the loop because the `while` is executed in a sub-shell because of the pipe `|`.

* line 69:
	* `tr` reads from the standard input (not from an argument)
	* `[]` will be interpreted by the shell, not by `tr`
	* `A-z` is used instead of `A-Z`
	* `uniq -c` only considers consecutive lines
	* `sort` will sort lexicographically 1 &lt; 10 &lt; 2, not numerically
	* `head` will retrieve the 10 lowest values
	* `cut` will extract only the first letter of the name
	* eventually `for` will break apart first names and family names (space again...)

## Requirements and Installation

Nothing except a standard Unix system
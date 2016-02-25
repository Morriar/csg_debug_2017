# Ventilation

See `PUBLIC/README.md` for the challenge description.

## Bugs List

* usedVents, missing stop condition on i == 0
* usedVents, current is not decremented
* max function is wrong
* processAirvents calls UsedVents instead of callback
* result array is not sorted

Run `diff PRIVATE/src/airvents.js PUBLIC/src/airvents.js` for more details.

## Requirements and Installation

This challenge requires the following dependencies:

* nodejs v5.4.1
* npm v3.3.12

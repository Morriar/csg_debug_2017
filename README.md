# Debug Competition

Informations you will find in this README:
* competition description and rules
* general architecture
* how to install, initialize and run the debug competition.
* how to develop new challenges

## Description

In this competition, participant teams are evaluated on their ability to keep the
dome running.

Each team is assigned with an architecture composed of 15 essential systems like
oxygen production, aeration, cooling, energy production etc.
Those systems are buggy and need to be fixed before the dome runs out of its resources
and everyone dies.

## Rules

Each team is assigned with 15 bugs to fix.
At each round (5 min), a CRON task pings each bug in each team and checks if the
bug is fixed or not.

Each round, the dome consumes a part of its resources.
If a resource hits 0 for more than one round, people under the dome die and the team lose.

To counterbalance the dome consumption effect, teams must fix bugs in the main systems.
An up and running system produces a small amount of resources each turn its up.
### Bug challenges

### `PUBLIC` directory

The `PUBLIC` directory contains all the files that are given to the teams.
For obvious reasons, this directory should not contain anything related to backend
infrastructure, hidden test files, fixed version...

Minimal files and directory are:

* `README.md`: Everything that the participants need to know about your challenge should be there.

  Provide a short description of the program.
  * What it is supposed to do or produce?
  * How to run it?
  * Special hints or jokes?

  Try to adopt a roleplay style, these programs are supposed to be related to the
  dome main systems.

* `Makefile`: To install, compile and test the program.

  The participants should pass most of the time debugging your program than trying
  to run it.
  Be fairplay and help them understand.

  A minimal Makefile should contain these goals:
  * `install` (optional if everything is already on the team computer)
  * `compile` (optional)
  *	`test` run the script `tests.sh`
  * `clean` remove all files created by previous goals

* `src/` the directory where the bugged sources of the program are.

* `tests.sh` a script that run the public tests.

  This allow to run all public tests in one command. It's only for the teams and
  for the public tests. Private and competition tests are stored elsewhere and runned
  through a totally different process.

  The basic version of `tests.sh` only cat the input file as argument of the program
  then pipe the std output to the output file.
  You can enhance it to pass more complex outputs.

* `tests/` tests inputs and outputs used by `tests.sh`.
  A test have two files located in the `tests/` directory:
  * `test_name.in` the input that will be given to the program
  * `test_name.res` the expected output of the program

* `.gitignore` git ignored files for the challenge repository.

TODO: Do we need to pre-initialize the git repository? See with @AlexLeblanc.

### `PRIVATE` directory

The `PRIVATE` directory contains the private files related to the challenge.
This directory SHOULD NOT be given to the particpants!

Minimal files are:

* `README.md`: Everything we need to know about your challenge should be there.

  Think about description, initialization, running, bug list and explanation,
  dependencies for installation (compilers, libs...).
  Also give some input and output examples.

* `src/` directory that contains the **fixed** version of the program.
  That version MUST be working correctly as it will be used to validate the
  private test files.
  It will also be helpful for the team submission review.

* `Makefile`: A link to `PUBLIC/Makefile`.
  You can use a different one here if you need more complex things for the
  development of the challenge.
  In this case, just make sure to keep the public one up to date.

* `tests.sh` the script used to check all input files from the `tests/` directory.
  Basically it's just a link to the PUBLIC one so we ensure that the private and public
  tests are checked in the same condition.

* `tests/` the private tests that will be used during the competition and the
  scoring. Tests follow the same format than in the `PUBLIC/tests/` directory.

  During the competition, the inputs for the team version will be choosen from
  this directory. Every challenge will be tested every 5 minutes for 3 hours.
  You will need ~36 inputs to fit the 3 hours but remenber that the tests will
  be selected randomly during the competition (so the teams can't predict what's
  comment next). So ~15 inputs should do the trick.

  It can also be a good idea to link the `PUBLIC/tests/` tests into the
  `PRIVATE/tests/` so they will also be checked in the process (and passed as
  input during the competition).

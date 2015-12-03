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

# Irrigation systems

Food under the Dome is a scarce resource.

Due to a lack of space, all the farming space must be extremely efficient to provide for people living under the Dome.

To ensure a maximum yield when harvesting, a highly performant irrigation system is mandatory for our survival.

Irrigation stations are in charge of how the distribution of water is done under the dome.

Each station has a system that can be efficiently paired only with certain stations.

To maximise the water throughput, stations must be positioned efficiently.

Which leads us to the program we have here.

It runs a placement simulation, the best yield is computed.

However, it does not run for now, and no one has a good knowledge of Haskell within our forces.

Can you debug it as fast as possible, the survival of humanity depends on you.

## Description

A list of placements is given as argument of the program.

It then parses the input and maps it with a series of edges.

A brute-force method to bind stations is then tried, the highest scoring disposition is kept, and its score is printed.

## Usage

./irrigation positioning_1.in
901

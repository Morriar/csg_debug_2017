# Atomic Engine

See `PUBLIC/README.md` for the challenge description.

## Bugs List

* `Simulator.java`: String comparison with `==`
* `Reactor.java`: unchecked negative values
* `ReactorGrid.java`: grod does not check first and last row before getting neighbors
* `ReactorSlot.java`: the setter always set null
* `ReactorRod.java`: the `baseEnergy` and `baseHeat` methods should be abstract
* `ControlRod.java`: baseHeat return value is commented, clusterHeat should always be begative (use `abs()`)
* `UraniumRod.java`: bad overriding of `baseEnergy` and `baseHeat`.
* `Coolant.java` `heatAbsorption` is commented.

Run `meld PRIVATE/src/ PUBLIC/src/`
for more details.

## Requirements and Installation

This challenge requires the following dependencies:

* java (version >= 1.7)
* javac (version >= 1.7)

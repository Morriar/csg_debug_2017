# Thermal Reactor

See `PUBLIC/README.md` for the challenge description.

## Bugs List

* `parseConfiguration`: probe names used twice are not checked
* `parseConfiguration`: probe names used twice are not checked
* `parseConfiguration`: invalid level index are not checked
* `ThermalConfiguration::renderReport`: maxLevel is set at every iteration, it should be based on a max check
* `ThermalConfiguration::renderReport`: level should be check against `i` not `j`
* `ThermalConfiguration::isEmpty`: the method does not check if probe are deployed
* `ThermalProbe::isDeployed`: the method does not check if level == null

Run `diff PRIVATE/src/ThermalConfigurator.java PUBLIC/src/ThermalConfigurator.java`
for more details.

## Requirements and Installation

This challenge requires the following dependencies:

* java (version >= 1.7)
* javac (version >= 1.7)

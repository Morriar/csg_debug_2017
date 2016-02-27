# Copyright Dome Systems.
#
# Dome Private License (D-PL) [a369] PubPL 36 (7 Gallium 369)
#
# * URL: http://csgames.org/2016/dome_license.md
# * Type: Software
# * Media: Software
# * Origin: Mines of Morriar
# * Author: Morriar

compile:
	mkdir -p bin/
	javac -d bin/ src/sim/Simulator.java \
		src/sim/reactor/Reactor.java \
		src/sim/reactor/ReactorGrid.java \
		src/sim/reactor/ReactorItem.java \
		src/sim/reactor/ReactorSlot.java \
		src/sim/reactor/items/ReactorRod.java \
		src/sim/reactor/items/ControlRod.java \
		src/sim/reactor/items/UraniumRod.java \
		src/sim/reactor/items/Coolant.java

test:
	./tests.sh

clean:
	rm -rf bin/ out/

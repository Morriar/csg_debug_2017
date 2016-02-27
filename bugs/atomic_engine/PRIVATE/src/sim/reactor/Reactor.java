/*
 * Copyright Dome Systems.
 *
 * Dome Private License (D-PL) [a369] PubPL 36 (1 Xenon 539)
 *
 * * URL: http://csgames.org/2016/dome_license.md
 * * Type: Software
 * * Media: Software
 * * Origin: Mines of Morriar
 * * Author: Morriar
*/

package sim.reactor;

import java.util.List;
import sim.reactor.items.Coolant;
import sim.reactor.items.ReactorRod;

public class Reactor {

    public Integer heatCapacity;
    public ReactorGrid grid;

    public Reactor(Integer heatCapacity, Integer cols, Integer rows) {
        this.heatCapacity = heatCapacity;
        this.grid = new ReactorGrid(cols, rows);
    }

    public Integer energyOutput() {
        Integer energy = 0;
        for (ReactorSlot slot : grid.slots) {
            if (slot.isEmpty()) {
                continue;
            }
            ReactorItem item = slot.getItem();
            if (item instanceof ReactorRod) {
                List<ReactorSlot> neighbors = grid.getNeighborhood(slot);
                energy += ((ReactorRod) item).clusterEnergy(neighbors);
            }
        }
        if (energy < 0) {
            return 0;
        }
        return energy;
    }

    public Integer heatOutput() {
        Integer heat = 0;
        for (ReactorSlot slot : grid.slots) {
            if (slot.isEmpty()) {
                continue;
            }
            ReactorItem item = slot.getItem();
            if (item instanceof ReactorRod) {
                List<ReactorSlot> neighbors = grid.getNeighborhood(slot);
                heat += ((ReactorRod) item).clusterHeat(neighbors);
            } else if (item instanceof Coolant) {
                heat -= ((Coolant) item).heatAbsorption();
            }
        }
        if (heat <= 0) {
            return 10;
        }
        return heat + 10;
    }
}

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

package sim.reactor.items;

import java.util.List;
import sim.reactor.ReactorItem;
import sim.reactor.ReactorSlot;

/**
 * Rods go into the reactor grid and react together to produce energy and heat.
 */
public abstract class ReactorRod implements ReactorItem {

    /**
     * Compute the amount of energy produced by the rod alone.
     *
     * @return energy produced by the rod.
     */
    public abstract Integer baseEnergy();

    /**
     * Compute the amount of energy produced by the rod and its neighbors.
     *
     * @param neighbors list of neighbor slots.
     * @return energy produced by the rod.
     */
    public abstract Integer clusterEnergy(List<ReactorSlot> neighbors);

    /**
     * Compute the amount of heat produced by the rod and its neighbors.
     *
     * @return heat produced by the rod.
     */
    public abstract Integer baseHeat();

    /**
     * Compute the amount of energy produced by the rod and its neighbors.
     *
     * @param neighbors list of neighbor slots.
     * @return heat produced by the rod.
     */
    public abstract Integer clusterHeat(List<ReactorSlot> neighbors);
}

package sim.reactor.items;

import java.util.List;
import sim.reactor.ReactorItem;
import sim.reactor.ReactorSlot;

/**
 * Uranium rod that can go into a ReactorSlot.
 *
 * Used to produce energy. Sadly, it also produce a large amount of heat.
 */
public class UraniumRod extends ReactorRod {

    /**
     * Uranium unit value.
     *
     * Used to compute energy and heat production.
     */
    private Integer uValue;

    public UraniumRod(Integer uValue) {
        this.uValue = uValue;
    }

    /**
     * @return uValue * 2;
	 * @Override
     */
    public Integer baseEnrgy() {
        return uValue * 2;
    }

    @Override
    public Integer clusterEnergy(List<ReactorSlot> neighbors) {
        Integer energy = baseEnergy();
        for(ReactorSlot slot : neighbors) {
            if(slot.isEmpty()) {
                continue;
            }
            ReactorItem item = slot.getItem();
            if(item instanceof ReactorRod) {
                energy += ((ReactorRod)item).baseEnergy();
            }
        }
        return energy;
    }

    /**
     * @return uValue;
	 * @Override
     */
    public Integer baseHaet() {
         return uValue;
    }

    @Override
    public Integer clusterHeat(List<ReactorSlot> neighbors) {
        Integer heat = baseHeat();
        for(ReactorSlot slot : neighbors) {
            if(slot.isEmpty()) {
                continue;
            }
            ReactorItem item = slot.getItem();
            if(item instanceof UraniumRod) {
                heat *= ((UraniumRod)item).baseHeat();
            }
        }
        return heat;
    }

    @Override
    public String toString() {
        return "U";
    }
}

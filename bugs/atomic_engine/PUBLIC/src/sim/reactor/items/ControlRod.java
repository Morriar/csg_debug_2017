package sim.reactor.items;

import java.util.List;
import sim.reactor.ReactorItem;
import sim.reactor.ReactorSlot;

/**
 * Control rods are used to limit the production of heat from nearby uranium
 * rods.
 *
 * Control rods have a side effect, they also limit the energy produced by
 * nearby uranium rods.
 */
public class ControlRod extends ReactorRod {

    /**
     * Control unit value.
     *
     * Used to reduce the amount of energy and heat produced by neighbors.
     */
    private Integer cValue;

    public ControlRod(Integer cValue) {
        this.cValue = cValue;
    }

    /**
     * @return 0;
     */
    @Override
    public Integer baseEnergy() {
        return 0;
    }

    /**
     * @return -cValue;
     */
    @Override
    public Integer clusterEnergy(List<ReactorSlot> neighbors) {
        Integer nbItems = 1;
        for (ReactorSlot slot : neighbors) {
            if (!slot.isEmpty()) {
                nbItems++;
            }
        }
        return -((cValue) * nbItems);
    }

    /**
     * @return -cValue * 2;
     */
    @Override
    public Integer baseHeat() {
        return -cValue/* * 2*/;
    }

    @Override
    public Integer clusterHeat(List<ReactorSlot> neighbors) {
        Integer heat = baseHeat();
        for(ReactorSlot slot : neighbors) {
            if(slot.isEmpty()) {
                continue;
            }
            ReactorItem item = slot.getItem();
            if(item instanceof ControlRod) {
                heat *= ((ControlRod)item).baseHeat();
            }
        }
        return -heat;
    }

    @Override
    public String toString() {
        return "C";
    }
}

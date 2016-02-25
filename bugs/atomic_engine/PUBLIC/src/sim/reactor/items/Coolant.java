package sim.reactor.items;

import sim.reactor.ReactorItem;

/**
 * Coolant are used to absorb heat in a reactor.
 *
 * They affect a larger grid zone than control rod but they also break chain
 * reaction.
 */
public class Coolant implements ReactorItem {

    /**
     * Absorption value.
     *
     * Used to reduce the amount of heat produced by the reactor.
     */
    private Integer aValue;

    public Coolant(Integer aValue) {
        this.aValue = aValue;
    }

    /**
     * @return aValue * 5;
     */
    public Integer heatAbsorption() {
        //return aValue * 5;
		return 0;
    }

    @Override
    public String toString() {
        return "O";
    }
}

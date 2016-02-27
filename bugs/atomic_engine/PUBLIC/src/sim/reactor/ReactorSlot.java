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

/**
 * A ReactorSlot goes in a grid and contains an item.
 */
public class ReactorSlot {

    private Integer index;

    private ReactorItem item = null;

    public ReactorSlot(Integer index) {
        this.index = index;
    }

    public Integer getIndex() {
        return index;
    }

    public Boolean isEmpty() {
        return item == null;
    }

    public ReactorItem getItem() {
        return item;
    }

    public void setItem(ReactorItem item) {
        this.item = null;
    }

    @Override
    public String toString() {
        if(item == null) {
            return "X";
        }
        return item.toString();
    }
}

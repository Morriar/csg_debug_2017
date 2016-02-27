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

import java.util.ArrayList;
import java.util.List;

public class ReactorGrid {

    protected Integer cols, rows;
    protected List<ReactorSlot> slots;

    public ReactorGrid(Integer cols, Integer rows) {
        this.cols = cols;
        this.rows = rows;
        slots = new ArrayList<>(rows * cols);
        for(int i = 0; i < rows * cols; i++) {
            slots.add(new ReactorSlot(i));
        }
    }

    public ReactorSlot getSlot(Integer col, Integer row) {
        return slots.get(col + row * cols);
    }

    /**
     * Neighbors slots.
     *
     * @param slot to find neighbors of.
     * @return list of neighbors without `slot`.
     */
    public List<ReactorSlot> getNeighborhood(ReactorSlot slot) {
        ArrayList<ReactorSlot> neighbors = new ArrayList<>();

        Integer col = slot.getIndex() % cols;
        Integer row = slot.getIndex() / cols;

        if(col > 0) {
            if(row > 0) {
                neighbors.add(getSlot(col - 1, row - 1));
            }
            neighbors.add(getSlot(col - 1, row));
            if(row < rows - 1) {
                neighbors.add(getSlot(col - 1, row + 1));
            }
        }
        if(row > 0) {
            neighbors.add(getSlot(col, row - 1));
        }
        if(row < rows - 1) {
            neighbors.add(getSlot(col, row + 1));
        }
        if(col < cols - 1) {
            if(row > 0) {
                neighbors.add(getSlot(col + 1, row - 1));
            }
            neighbors.add(getSlot(col + 1, row));
            if(row < rows - 1) {
                neighbors.add(getSlot(col + 1, row + 1));
            }
        }

        return neighbors;
    }

    public void displayGrid() {
        for(int i = 0; i < cols * rows; i++) {
            if(i != 0 && i % cols == 0) {
                System.out.print("\n");
            }
            System.out.print(" " + slots.get(i));
        }
        System.out.println("");
    }
}

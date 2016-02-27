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

import sim.reactor.ReactorGrid;
import org.junit.Test;
import static org.junit.Assert.*;
import sim.reactor.items.Coolant;

public class ReactorGridTest {

    @Test
    public void testGrid1x1() {
        ReactorGrid r = new ReactorGrid(1, 1);
        assertTrue(r.getNeighborhood(r.getSlot(0, 0)).isEmpty());

        r = new ReactorGrid(1, 1);
        r.getSlot(0, 0).setItem(new Coolant(10));
        assertTrue(r.getNeighborhood(r.getSlot(0, 0)).isEmpty());
    }

    @Test
    public void testGrid1x2() {
        ReactorGrid r = new ReactorGrid(1, 2);
        assertEquals(1, r.getNeighborhood(r.getSlot(0, 0)).size());

        r = new ReactorGrid(1, 2);
        r.getSlot(0, 0).setItem(new Coolant(10));
        assertEquals(1, r.getNeighborhood(r.getSlot(0, 0)).size());
    }

    @Test
    public void testGrid2x2() {
        ReactorGrid r = new ReactorGrid(2, 2);
        assertEquals(3, r.getNeighborhood(r.getSlot(0, 0)).size());
        assertEquals(3, r.getNeighborhood(r.getSlot(0, 1)).size());
        assertEquals(3, r.getNeighborhood(r.getSlot(1, 0)).size());
        assertEquals(3, r.getNeighborhood(r.getSlot(1, 1)).size());
    }

    @Test
    public void testEnergy3x3() {
        ReactorGrid r = new ReactorGrid(3, 3);
        assertEquals(3, r.getNeighborhood(r.getSlot(0, 0)).size());
        assertEquals(5, r.getNeighborhood(r.getSlot(0, 1)).size());
        assertEquals(3, r.getNeighborhood(r.getSlot(0, 2)).size());
        assertEquals(5, r.getNeighborhood(r.getSlot(1, 0)).size());
        assertEquals(8, r.getNeighborhood(r.getSlot(1, 1)).size());
        assertEquals(5, r.getNeighborhood(r.getSlot(1, 2)).size());
        assertEquals(3, r.getNeighborhood(r.getSlot(2, 0)).size());
        assertEquals(5, r.getNeighborhood(r.getSlot(2, 1)).size());
        assertEquals(3, r.getNeighborhood(r.getSlot(2, 2)).size());
    }
}

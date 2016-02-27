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

import sim.reactor.Reactor;
import org.junit.Test;
import static org.junit.Assert.*;
import sim.reactor.items.Coolant;
import sim.reactor.items.ControlRod;
import sim.reactor.items.UraniumRod;

public class ReactorTest {

    @Test(expected = IndexOutOfBoundsException.class)
    public void test0x0() {
        Reactor r = new Reactor(1000, 0, 0);
        assertEquals(0, (int) r.energyOutput());
        assertEquals(10, (int) r.heatOutput());

        r = new Reactor(1000, 0, 0);
        r.grid.getSlot(0, 0).setItem(new UraniumRod(10));
    }

    @Test
    public void test1x1() {
        Reactor r = new Reactor(1000, 1, 1);
        assertEquals(0, (int) r.energyOutput());
        assertEquals(10, (int) r.heatOutput());

        r = new Reactor(1000, 1, 1);
        r.grid.getSlot(0, 0).setItem(new UraniumRod(10));
        assertEquals(20, (int) r.energyOutput());
        assertEquals(20, (int) r.heatOutput());

        r = new Reactor(1000, 1, 1);
        r.grid.getSlot(0, 0).setItem(new ControlRod(10));
        assertEquals(0, (int) r.energyOutput());
        assertEquals(10, (int) r.heatOutput());

        r = new Reactor(1000, 1, 1);
        r.grid.getSlot(0, 0).setItem(new Coolant(10));
        assertEquals(0, (int) r.energyOutput());
        assertEquals(10, (int) r.heatOutput());
    }

    @Test
    public void test1x2() {
        Reactor r = new Reactor(1000, 1, 2);
        r.grid.getSlot(0, 0).setItem(new UraniumRod(10));
        r.grid.getSlot(0, 1).setItem(new UraniumRod(10));
        assertEquals(80, (int) r.energyOutput());
        assertEquals(210, (int) r.heatOutput());

        r = new Reactor(1000, 1, 2);
        r.grid.getSlot(0, 0).setItem(new ControlRod(10));
        r.grid.getSlot(0, 1).setItem(new ControlRod(10));
        assertEquals(0, (int) r.energyOutput());
        assertEquals(10, (int) r.heatOutput());

        r = new Reactor(1000, 1, 2);
        r.grid.getSlot(0, 0).setItem(new UraniumRod(10));
        r.grid.getSlot(0, 1).setItem(new ControlRod(2));
        assertEquals(16, (int) r.energyOutput());
        assertEquals(16, (int) r.heatOutput());

        r = new Reactor(1000, 1, 2);
        r.grid.getSlot(0, 0).setItem(new UraniumRod(10));
        r.grid.getSlot(0, 1).setItem(new Coolant(10));
        assertEquals(20, (int) r.energyOutput());
        assertEquals(10, (int) r.heatOutput());

        r = new Reactor(1000, 1, 2);
        r.grid.getSlot(0, 0).setItem(new ControlRod(10));
        r.grid.getSlot(0, 1).setItem(new Coolant(10));
        assertEquals(0, (int) r.energyOutput());
        assertEquals(10, (int) r.heatOutput());
    }

    @Test
    public void test2x2() {
        Reactor r = new Reactor(1000, 2, 2);
        r.grid.getSlot(0, 0).setItem(new UraniumRod(10));
        r.grid.getSlot(0, 1).setItem(new UraniumRod(10));
        r.grid.getSlot(1, 0).setItem(new UraniumRod(10));
        r.grid.getSlot(1, 1).setItem(new UraniumRod(10));
        assertEquals(320, (int) r.energyOutput());
        assertEquals(40010, (int) r.heatOutput());

        r = new Reactor(1000, 2, 2);
        r.grid.getSlot(0, 0).setItem(new UraniumRod(10));
        r.grid.getSlot(0, 1).setItem(new ControlRod(2));
        r.grid.getSlot(1, 0).setItem(new ControlRod(2));
        r.grid.getSlot(1, 1).setItem(new UraniumRod(10));
        assertEquals(64, (int) r.energyOutput());
        assertEquals(178, (int) r.heatOutput());

        r = new Reactor(1000, 2, 2);
        r.grid.getSlot(0, 0).setItem(new UraniumRod(10));
        r.grid.getSlot(0, 1).setItem(new Coolant(2));
        r.grid.getSlot(1, 0).setItem(new ControlRod(2));
        r.grid.getSlot(1, 1).setItem(new UraniumRod(10));
        assertEquals(72, (int) r.energyOutput());
        assertEquals(196, (int) r.heatOutput());
    }

    @Test
    public void test3x3() {
        Reactor r = new Reactor(1000, 3, 3);
        r.grid.getSlot(0, 0).setItem(new UraniumRod(10));
        r.grid.getSlot(0, 1).setItem(new UraniumRod(10));
        r.grid.getSlot(0, 2).setItem(new UraniumRod(10));
        r.grid.getSlot(1, 0).setItem(new UraniumRod(10));
        r.grid.getSlot(1, 1).setItem(new UraniumRod(10));
        r.grid.getSlot(1, 2).setItem(new UraniumRod(10));
        r.grid.getSlot(2, 0).setItem(new UraniumRod(10));
        r.grid.getSlot(2, 1).setItem(new UraniumRod(10));
        r.grid.getSlot(2, 2).setItem(new UraniumRod(10));
        assertEquals(980, (int) r.energyOutput());
        assertEquals(1004040010, (int) r.heatOutput());

        r = new Reactor(1000, 3, 3);
        r.grid.getSlot(0, 0).setItem(new UraniumRod(10));
        r.grid.getSlot(0, 1).setItem(new ControlRod(2));
        r.grid.getSlot(0, 2).setItem(new UraniumRod(10));
        r.grid.getSlot(1, 0).setItem(new ControlRod(2));
        r.grid.getSlot(1, 1).setItem(new UraniumRod(10));
        r.grid.getSlot(1, 2).setItem(new ControlRod(2));
        r.grid.getSlot(2, 0).setItem(new UraniumRod(10));
        r.grid.getSlot(2, 1).setItem(new ControlRod(2));
        r.grid.getSlot(2, 2).setItem(new UraniumRod(10));
        assertEquals(212, (int) r.energyOutput());
        assertEquals(100154, (int) r.heatOutput());

        r = new Reactor(1000, 3, 3);
        r.grid.getSlot(0, 0).setItem(new UraniumRod(10));
        r.grid.getSlot(0, 1).setItem(new ControlRod(2));
        r.grid.getSlot(0, 2).setItem(new UraniumRod(10));
        r.grid.getSlot(1, 0).setItem(new ControlRod(2));
        r.grid.getSlot(1, 1).setItem(new Coolant(10));
        r.grid.getSlot(1, 2).setItem(new ControlRod(2));
        r.grid.getSlot(2, 0).setItem(new UraniumRod(10));
        r.grid.getSlot(2, 1).setItem(new ControlRod(2));
        r.grid.getSlot(2, 2).setItem(new UraniumRod(10));
        assertEquals(32, (int) r.energyOutput());
        assertEquals(10, (int) r.heatOutput());
    }
}

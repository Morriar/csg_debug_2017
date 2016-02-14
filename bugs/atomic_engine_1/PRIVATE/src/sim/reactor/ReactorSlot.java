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
        this.item = item;
    }

    @Override
    public String toString() {
        if(item == null) {
            return "X";
        }
        return item.toString();
    }
}
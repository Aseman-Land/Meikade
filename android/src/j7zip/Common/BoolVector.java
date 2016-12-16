/*
    Copyright (C) 2017 Aseman Team
    http://aseman.co

    Meikade is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Meikade is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

package Common;

public class BoolVector {
    
    protected boolean[] data = new boolean[10];
    int capacityIncr = 10;
    int elt = 0;
    
    public BoolVector() {
    }
    
    public int size() {
        return elt;
    }
    
    private void ensureCapacity(int minCapacity) {
        int oldCapacity = data.length;
        if (minCapacity > oldCapacity) {
            boolean [] oldData = data;
            int newCapacity = oldCapacity + capacityIncr;
            if (newCapacity < minCapacity) {
                newCapacity = minCapacity;
            }
            data = new boolean[newCapacity];
            System.arraycopy(oldData, 0, data, 0, elt);
        }
    }
    
    public boolean get(int index) {
        if (index >= elt)
            throw new ArrayIndexOutOfBoundsException(index);
        
        return data[index];
    }
    
    public void Reserve(int s) {
        ensureCapacity(s);
    }
    
    public void add(boolean b) {
        ensureCapacity(elt + 1);
        data[elt++] = b;
    }
    
    public void clear() {
        elt = 0;
    }
    
    public boolean isEmpty() {
        return elt == 0;
    }
}

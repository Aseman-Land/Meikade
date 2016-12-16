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

public class LongVector {
    protected long[] data = new long[10];
    int capacityIncr = 10;
    int elt = 0;
    
    public LongVector() {
    }
    
    public int size() {
        return elt;
    }
    
    private void ensureCapacity(int minCapacity) {
        int oldCapacity = data.length;
        if (minCapacity > oldCapacity) {
            long [] oldData = data;
            int newCapacity = oldCapacity + capacityIncr;
            if (newCapacity < minCapacity) {
                newCapacity = minCapacity;
            }
            data = new long[newCapacity];
            System.arraycopy(oldData, 0, data, 0, elt);
        }
    }
    
    public long get(int index) {
        if (index >= elt)
            throw new ArrayIndexOutOfBoundsException(index);
        
        return data[index];
    }
    
    public void Reserve(int s) {
        ensureCapacity(s);
    }
    
    public void add(long b) {
        ensureCapacity(elt + 1);
        data[elt++] = b;
    }
    
    public void clear() {
        elt = 0;
    }
    
    public boolean isEmpty() {
        return elt == 0;
    }
    
    public long Back() {
        if (elt < 1)
            throw new ArrayIndexOutOfBoundsException(0);
        
        return data[elt-1];
    }
    
    public long Front() {
        if (elt < 1)
            throw new ArrayIndexOutOfBoundsException(0);
        
        return data[0];
    }
    
    public void DeleteBack() {
        // Delete(_size - 1);
        remove(elt-1);
    }
    
    public long remove(int index) {
        if (index >= elt)
            throw new ArrayIndexOutOfBoundsException(index);
        long oldValue = data[index];
        
        int numMoved = elt - index - 1;
        if (numMoved > 0)
            System.arraycopy(elt, index+1, elt, index,numMoved);
        
        // data[--elt] = null; // Let gc do its work
        
        return oldValue;
    }
    
}

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

public class ByteBuffer {
    int _capacity;
    byte [] _items;
    
    public ByteBuffer() {
        _capacity = 0;
        _items = null;
    }
    
    public byte [] data() { return _items; }
    
    public int GetCapacity() { return  _capacity; }
    
    public void SetCapacity(int newCapacity) {
        if (newCapacity == _capacity)
            return;
        
        byte [] newBuffer;
        if (newCapacity > 0) {
            newBuffer = new byte[newCapacity];
            if(_capacity > 0) {
                int len = _capacity;
                if (newCapacity < len) len = newCapacity;
                
                System.arraycopy(_items,0,newBuffer,0,len); // for (int i = 0 ; i < len ; i++) newBuffer[i] = _items[i];
            }
        } else
            newBuffer = null;
        
        // delete []_items;
        _items = newBuffer;
        _capacity = newCapacity;
    }
}

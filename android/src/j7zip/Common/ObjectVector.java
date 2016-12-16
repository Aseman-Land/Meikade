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

public class ObjectVector<E> extends java.util.Vector<E>
{
    public ObjectVector() {
        super();
    }
    
    public void Reserve(int s) {
        ensureCapacity(s);
    }
    
    public E Back() {
        return get(elementCount-1);
    }
    
    public E Front() {
        return get(0);
    }
    
    public void DeleteBack() {
        remove(elementCount-1);
    }
}

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

public class LockedSequentialInStreamImp extends java.io.InputStream {
    LockedInStream _lockedInStream;
    long _pos;
    
    public LockedSequentialInStreamImp() {
    }
    
    public void Init(LockedInStream lockedInStream, long startPos) {
        _lockedInStream = lockedInStream;
        _pos = startPos;
    }
    
    public int read() throws java.io.IOException {
        throw new java.io.IOException("LockedSequentialInStreamImp : read() not implemented");
        /*
        int ret = _lockedInStream.read(_pos);
        if (ret == -1) return -1; // EOF
         
        _pos += 1;
         
        return ret;
         */
    }
    
    public int read(byte [] data, int off, int size) throws java.io.IOException {
        int realProcessedSize = _lockedInStream.read(_pos, data,off, size);
        if (realProcessedSize == -1) return -1; // EOF
        
        _pos += realProcessedSize;
        
        return realProcessedSize;
    }
    
}

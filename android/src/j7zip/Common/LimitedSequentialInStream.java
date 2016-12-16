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

public class LimitedSequentialInStream extends java.io.InputStream {
    java.io.InputStream _stream; // ISequentialInStream
    long _size;
    long _pos;
    boolean _wasFinished;
    
    public LimitedSequentialInStream() {
    }
    
    public void SetStream(java.io.InputStream stream) { // ISequentialInStream
        _stream = stream;
    }
    
    public void Init(long streamSize) {
        _size = streamSize;
        _pos = 0;
        _wasFinished = false;
    }
    
    public int read() throws java.io.IOException {
        int ret = _stream.read();
        if (ret == -1) _wasFinished = true;
        return ret;
    }
    
    public int read(byte [] data,int off, int size) throws java.io.IOException {
        long sizeToRead2 = (_size - _pos);
        if (size < sizeToRead2) sizeToRead2 = size;
        
        int sizeToRead = (int)sizeToRead2;
        
        if (sizeToRead > 0) {
            int realProcessedSize = _stream.read(data, off, sizeToRead);
            if (realProcessedSize == -1) {
                _wasFinished = true;
                return -1;
            }
            _pos += realProcessedSize;
            return realProcessedSize;
        }
        
        return -1; // EOF
    }
}

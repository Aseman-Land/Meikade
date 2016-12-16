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

package SevenZip.Archive.SevenZip;
import java.io.IOException;

class InByte2 {
    byte [] _buffer;
    int _size;
    int _pos;
    
    public void Init(byte [] buffer, int size) {
        _buffer = buffer;
        _size = size;
        _pos = 0;
    }
    public int ReadByte() throws IOException {
        if(_pos >= _size)
            throw new IOException("CInByte2 - Can't read stream");
        return (_buffer[_pos++] & 0xFF);
    }
    
    int ReadBytes2(byte [] data, int size) {
        int processedSize;
        for(processedSize = 0; processedSize < size && _pos < _size; processedSize++)
            data[processedSize] = _buffer[_pos++];
        return processedSize;
    }
    
    boolean ReadBytes(byte [] data, int size) {
        int processedSize = ReadBytes2(data, size);
        return (processedSize == size);
    }
    
    int GetProcessedSize() { return _pos; }
    
    InByte2() {
    }
}

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

package SevenZip.Common;

import java.io.IOException;
import SevenZip.HRESULT;

public class SequentialOutStreamImp2 extends java.io.OutputStream {
    byte []_buffer;
    int _size;
    int _pos;
    public void Init(byte [] buffer, int size) {
        _buffer = buffer;
        _pos = 0;
        _size = size;
    }
    
    public void write(int b) throws java.io.IOException {
        throw new java.io.IOException("SequentialOutStreamImp2 - write() not implemented");
    }
    
    public void write(byte [] data,int off, int size) throws java.io.IOException {
        for(int i = 0 ; i < size ; i++) {
            if (_pos < _size) {
                _buffer[_pos++] = data[off + i];
            } else {
                throw new java.io.IOException("SequentialOutStreamImp2 - can't write");
            }
        }
    }
}

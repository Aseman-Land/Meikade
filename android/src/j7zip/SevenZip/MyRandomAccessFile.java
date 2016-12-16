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

package SevenZip;

public  class MyRandomAccessFile extends SevenZip.IInStream  {
    
    java.io.RandomAccessFile _file;
    
    MyRandomAccessFile(String filename,String mode)  throws java.io.IOException {
        _file  = new java.io.RandomAccessFile(filename,mode);
    }
    
    public long Seek(long offset, int seekOrigin)  throws java.io.IOException {
        if (seekOrigin == STREAM_SEEK_SET) {
            _file.seek(offset);
        }
        else if (seekOrigin == STREAM_SEEK_CUR) {
            _file.seek(offset + _file.getFilePointer());
        }
        return _file.getFilePointer();
    }
    
    public int read() throws java.io.IOException {
        return _file.read();
    }
 
    public int read(byte [] data, int off, int size) throws java.io.IOException {
        return _file.read(data,off,size);
    }
        
    public int read(byte [] data, int size) throws java.io.IOException {
        return _file.read(data,0,size);
    }
    
    public void close() throws java.io.IOException {
        _file.close();
        _file = null;
    }   
}

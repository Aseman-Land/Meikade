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

import SevenZip.IInStream;

public class LockedInStream {
    IInStream _stream;
    
    public LockedInStream() {
    }
    
    public void Init(IInStream stream) {
        _stream = stream;
    }
    
    /* really too slow, don't use !
    public synchronized int read(long startPos) throws java.io.IOException
    {
        // NWindows::NSynchronization::CCriticalSectionLock lock(_criticalSection);
        _stream.Seek(startPos, IInStream.STREAM_SEEK_SET);
        return _stream.read();
    }
     */
    
    public synchronized int read(long startPos, byte  [] data, int size) throws java.io.IOException {
        // NWindows::NSynchronization::CCriticalSectionLock lock(_criticalSection);
        _stream.Seek(startPos, IInStream.STREAM_SEEK_SET);
        return _stream.read(data,0, size);
    }
    
    public synchronized int read(long startPos, byte  [] data, int off, int size) throws java.io.IOException {
        // NWindows::NSynchronization::CCriticalSectionLock lock(_criticalSection);
        _stream.Seek(startPos, IInStream.STREAM_SEEK_SET);
        return _stream.read(data,off, size);
    }
}

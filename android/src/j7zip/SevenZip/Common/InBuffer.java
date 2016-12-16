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

public class InBuffer {
    int _bufferPos;
    int _bufferLimit;
    byte [] _bufferBase;
    java.io.InputStream _stream = null; // CMyComPtr<ISequentialInStream>
    long _processedSize;
    int _bufferSize;
    boolean _wasFinished;
    
    public InBuffer() {
        
    }
    // ~CInBuffer() { Free(); }
    
    public void Create(int bufferSize) {
        final int kMinBlockSize = 1;
        if (bufferSize < kMinBlockSize)
            bufferSize = kMinBlockSize;
        if (_bufferBase != null && _bufferSize == bufferSize)
            return ;
        Free();
        _bufferSize = bufferSize;
        _bufferBase = new byte[bufferSize];
    }
    void Free() {
        _bufferBase = null;
    }
    
    public void SetStream(java.io.InputStream stream) { // ISequentialInStream
        _stream = stream;
    }
    public void Init() {
        _processedSize = 0;
        _bufferPos = 0; //  = _bufferBase;
        _bufferLimit = 0; // _buffer;
        _wasFinished = false;
    }
    public void ReleaseStream() throws java.io.IOException {
        if (_stream != null) _stream.close(); // _stream.Release();
        _stream = null;
    }
    
    public int read()  throws java.io.IOException {
        if(_bufferPos >= _bufferLimit)
            return ReadBlock2();
        return _bufferBase[_bufferPos++] & 0xFF;
    }
    
    public boolean ReadBlock() throws java.io.IOException {
        if (_wasFinished)
            return false;
        _processedSize += _bufferPos; // (_buffer - _bufferBase);
        
        int  numProcessedBytes = _stream.read(_bufferBase, 0,_bufferSize);
        if (numProcessedBytes == -1) numProcessedBytes = 0; // EOF
        
        _bufferPos = 0; // _bufferBase;
        _bufferLimit = numProcessedBytes; // _buffer + numProcessedBytes;
        _wasFinished = (numProcessedBytes == 0);
        return (!_wasFinished);
    }
    
    public int ReadBlock2() throws java.io.IOException {
        if(!ReadBlock())
            return -1; // 0xFF;
        return _bufferBase[_bufferPos++] & 0xFF;
    }
    
    public long GetProcessedSize() { return _processedSize + (_bufferPos); }
    public boolean WasFinished() { return _wasFinished; }
}

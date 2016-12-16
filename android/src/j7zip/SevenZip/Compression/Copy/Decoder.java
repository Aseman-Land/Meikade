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

package SevenZip.Compression.Copy;

import java.io.IOException;

import SevenZip.ICompressCoder;
import SevenZip.ICompressProgressInfo;
import SevenZip.HRESULT;
import Common.RecordVector;

public class Decoder implements ICompressCoder {
    
    static final int kBufferSize = 1 << 17;
    
    public int Code(
            java.io.InputStream inStream, // , ISequentialInStream
            java.io.OutputStream outStream, // ISequentialOutStream
            long outSize, ICompressProgressInfo progress) throws java.io.IOException {
        
        byte [] _buffer = new byte[kBufferSize];
        long TotalSize = 0;
        
        for (;;) {
            int realProcessedSize;
            int size = kBufferSize;
            
            if (outSize != -1) // NULL
                if (size > (outSize - TotalSize))
                    size = (int)(outSize - TotalSize);
            
            realProcessedSize = inStream.read(_buffer, 0,size);
            if(realProcessedSize == -1) // EOF
                break;
            outStream.write(_buffer,0,realProcessedSize);
            TotalSize += realProcessedSize;
            if (progress != null) {
                int res = progress.SetRatioInfo(TotalSize, TotalSize);
                if (res != HRESULT.S_OK) return res;
            }
        }
        return HRESULT.S_OK;  
    }
}

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

public class StreamUtils
{    
    static public int  ReadStream(java.io.InputStream stream, byte [] data,int off, int size) throws IOException
    {
        int processedSize = 0;

        while(size != 0)
        {
             int processedSizeLoc = stream.read(data,off + processedSize,size);
             if (processedSizeLoc > 0)
             {
                processedSize += processedSizeLoc;
                size -= processedSizeLoc;
             }
             if (processedSizeLoc == -1) {
                 if (processedSize > 0) return processedSize;
                 return -1; // EOF
             }
        }
        return processedSize;
    }
    
    // HRESULT WriteStream(ISequentialOutStream *stream, const void *data, UInt32 size, UInt32 *processedSize);
}

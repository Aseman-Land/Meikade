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

package SevenZip.Archive;

import SevenZip.IInStream;
import java.io.IOException;

public interface IInArchive {
    public final static int NExtract_NAskMode_kExtract = 0;
    public final static int NExtract_NAskMode_kTest = 1;
    public final static int NExtract_NAskMode_kSkip = 2;
    
    public final static int NExtract_NOperationResult_kOK = 0;
    public final static int NExtract_NOperationResult_kUnSupportedMethod = 1;
    public final static int NExtract_NOperationResult_kDataError = 2;
    public final static int NExtract_NOperationResult_kCRCError = 3;
    
    // Static-SFX (for Linux) can be big.
    public final long kMaxCheckStartPosition = 1 << 22;
    
    SevenZipEntry getEntry(int index);
    
    int size();
    
    int close() throws IOException ;
    
    // Updated to include parent_dir argument [GAB, OpenLogic 2013-10-28]
    int Extract(int [] indices, int numItems,
            int testModeSpec, IArchiveExtractCallback extractCallbackSpec, 
            String parent_dir) throws java.io.IOException;
    
    int Open(IInStream stream) throws IOException;
    
    int Open(
            IInStream stream, // InStream *stream
            long maxCheckStartPosition // const UInt64 *maxCheckStartPosition,
            // IArchiveOpenCallback *openArchiveCallback */
            ) throws java.io.IOException;

    
}

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

class Header
{
    public static final int kSignatureSize = 6;
    public static byte [] kSignature= {'7', 'z', (byte)0xBC, (byte)0xAF, 0x27, 0x1C};
    public static byte kMajorVersion = 0;
    
    public class NID
    {
        public static final int kEnd = 0;      
        public static final int kHeader = 1;
        public static final int kArchiveProperties = 2;
        public static final int kAdditionalStreamsInfo = 3;
        public static final int kMainStreamsInfo = 4;
        public static final int kFilesInfo = 5;
    
        public static final int kPackInfo = 6;
        public static final int kUnPackInfo = 7;
        public static final int kSubStreamsInfo = 8;

        public static final int kSize = 9;
        public static final int kCRC = 10;
        
        public static final int kFolder = 11;
        public static final int kCodersUnPackSize = 12;
        public static final int kNumUnPackStream = 13;
 
        public static final int kEmptyStream = 14;
        public static final int kEmptyFile = 15;
        public static final int kAnti = 16;

        public static final int kName = 17;
        public static final int kCreationTime = 18;
        public static final int kLastAccessTime = 19;
        public static final int kLastWriteTime = 20;
        public static final int kWinAttributes = 21;
        public static final int kComment = 22;

        public static final int kEncodedHeader = 23;

        public static final int kStartPos = 24;
    }
}

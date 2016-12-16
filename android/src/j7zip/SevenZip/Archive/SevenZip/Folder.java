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

import Common.RecordVector;
import Common.IntVector;
import Common.LongVector;

import SevenZip.Archive.Common.BindPair;

class Folder {
    public RecordVector<CoderInfo> Coders = new RecordVector<CoderInfo>();
    RecordVector<BindPair> BindPairs = new RecordVector<BindPair>();
    IntVector PackStreams = new IntVector();
    LongVector UnPackSizes = new LongVector();
    int UnPackCRC;
    boolean UnPackCRCDefined;
    Folder() {
        UnPackCRCDefined = false;
    }

    long GetUnPackSize() throws IOException {
        if (UnPackSizes.isEmpty())
            return 0;
        for (int i = UnPackSizes.size() - 1; i >= 0; i--)
            if (FindBindPairForOutStream(i) < 0)
                return UnPackSizes.get(i);
        throw new IOException("1"); // throw 1  // TBD
    }
    
    int FindBindPairForInStream(int inStreamIndex) {
        for(int i = 0; i < BindPairs.size(); i++)
            if (BindPairs.get(i).InIndex == inStreamIndex)
                return i;
        return -1;
    }
    
    int FindBindPairForOutStream(int outStreamIndex) {
        for(int i = 0; i < BindPairs.size(); i++)
            if (BindPairs.get(i).OutIndex == outStreamIndex)
                return i;
        return -1;
    }
    
     int FindPackStreamArrayIndex(int inStreamIndex) {
        for(int i = 0; i < PackStreams.size(); i++)
            if (PackStreams.get(i) == inStreamIndex)
                return i;
        return -1;
    }
      
    int GetNumOutStreams() {
        int result = 0;
        for (int i = 0; i < Coders.size(); i++)
            result += Coders.get(i).NumOutStreams;
        return result;
    }
    
}

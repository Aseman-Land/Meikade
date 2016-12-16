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

package SevenZip.Archive.Common;

import Common.RecordVector;
import Common.IntVector;

public class BindInfo {
    public RecordVector<CoderStreamsInfo> Coders = new RecordVector<CoderStreamsInfo>();
    public RecordVector<BindPair> BindPairs = new RecordVector<BindPair>();
    public IntVector InStreams = new IntVector();
    public IntVector OutStreams = new IntVector();
    
    public void Clear() {
        Coders.clear();
        BindPairs.clear();
        InStreams.clear();
        OutStreams.clear();
    }
      
    public int FindBinderForInStream(int inStream) // const
    {
        for (int i = 0; i < BindPairs.size(); i++)
            if (BindPairs.get(i).InIndex == inStream)
                return i;
        return -1;
    }
    
    public int FindBinderForOutStream(int outStream) // const
    {
        for (int i = 0; i < BindPairs.size(); i++)
            if (BindPairs.get(i).OutIndex == outStream)
                return i;
        return -1;
    }
    
    public int GetCoderInStreamIndex(int coderIndex) // const
    {
        int streamIndex = 0;
        for (int i = 0; i < coderIndex; i++)
            streamIndex += Coders.get(i).NumInStreams;
        return streamIndex;
    }
    
    public int GetCoderOutStreamIndex(int coderIndex) // const
    {
        int streamIndex = 0;
        for (int i = 0; i < coderIndex; i++)
            streamIndex += Coders.get(i).NumOutStreams;
        return streamIndex;
    }
    
    public void FindInStream(int streamIndex,
            int [] coderIndex, // UInt32 &coderIndex
            int [] coderStreamIndex // UInt32 &coderStreamIndex
            )
            
    {
        for (coderIndex[0] = 0; coderIndex[0] < Coders.size(); coderIndex[0]++) {
            int curSize = Coders.get(coderIndex[0]).NumInStreams;
            if (streamIndex < curSize) {
                coderStreamIndex[0] = streamIndex;
                return;
            }
            streamIndex -= curSize;
        }
        throw new UnknownError("1");
    }
    
    public void FindOutStream(int streamIndex,
            int [] coderIndex, // UInt32 &coderIndex,
            int [] coderStreamIndex /* , UInt32 &coderStreamIndex */ ) {
        for (coderIndex[0] = 0; coderIndex[0] < Coders.size(); coderIndex[0]++) {
            int curSize = Coders.get(coderIndex[0]).NumOutStreams;
            if (streamIndex < curSize) {
                coderStreamIndex[0] = streamIndex;
                return;
            }
            streamIndex -= curSize;
        }
        throw new UnknownError("1");
    }
    
}

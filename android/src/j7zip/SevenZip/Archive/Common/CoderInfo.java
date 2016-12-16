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

import SevenZip.ICompressCoder;
import SevenZip.ICompressCoder2;

import Common.LongVector;

public class CoderInfo {
    ICompressCoder Coder;
    ICompressCoder2 Coder2;
    int NumInStreams;
    int NumOutStreams;
    
    LongVector InSizes = new LongVector();
    LongVector OutSizes = new LongVector();
    LongVector InSizePointers = new LongVector();
    LongVector OutSizePointers = new LongVector();
    
    public CoderInfo(int numInStreams, int numOutStreams) {
        NumInStreams = numInStreams;
        NumOutStreams = numOutStreams;
        InSizes.Reserve(NumInStreams);
        InSizePointers.Reserve(NumInStreams);
        OutSizePointers.Reserve(NumOutStreams);
        OutSizePointers.Reserve(NumOutStreams);
    }
    
    static public void SetSizes(
            LongVector srcSizes,
            LongVector sizes,
            LongVector sizePointers,
            int numItems)
    {
        sizes.clear();
        sizePointers.clear();
        for(int i = 0; i < numItems; i++) {
            if (srcSizes == null || srcSizes.get(i) == -1)  // TBD null => -1
            {
                sizes.add(new Long(0));
                sizePointers.add(-1);
            } else {
                sizes.add(srcSizes.get(i)); // sizes.Add(*srcSizes[i]);
                sizePointers.add(sizes.Back()); // sizePointers.Add(&sizes.Back());
            }
        }
    }
    
    public void SetCoderInfo(
            LongVector inSizes, //  const UInt64 **inSizes,
            LongVector outSizes) //const UInt64 **outSizes)
    {
        SetSizes(inSizes, InSizes, InSizePointers, NumInStreams);
        SetSizes(outSizes, OutSizes, OutSizePointers, NumOutStreams);
    }
}

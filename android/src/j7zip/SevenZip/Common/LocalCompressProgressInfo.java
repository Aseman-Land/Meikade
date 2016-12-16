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

import SevenZip.ICompressProgressInfo;
import SevenZip.IProgress;

public class LocalCompressProgressInfo implements ICompressProgressInfo {
    ICompressProgressInfo _progress;

    boolean _inStartValueIsAssigned;
    boolean _outStartValueIsAssigned;
    long _inStartValue;
    long _outStartValue;

    public void Init(ICompressProgressInfo progress, long inStartValue, long outStartValue) {

        _progress = progress;
        _inStartValueIsAssigned = (inStartValue != ICompressProgressInfo.INVALID);
        if (_inStartValueIsAssigned)
            _inStartValue = inStartValue;
        _outStartValueIsAssigned = (outStartValue != ICompressProgressInfo.INVALID);
        if (_outStartValueIsAssigned)
            _outStartValue = outStartValue;

    }
    
    public int SetRatioInfo(long inSize, long outSize) {
        long inSizeNew, outSizeNew;
        long inSizeNewPointer;
        long outSizeNewPointer;
        if (_inStartValueIsAssigned && inSize != ICompressProgressInfo.INVALID) {
            inSizeNew = _inStartValue + (inSize); // *inSize
            inSizeNewPointer = inSizeNew;
        } else
            inSizeNewPointer = ICompressProgressInfo.INVALID;
        
        if (_outStartValueIsAssigned && outSize != ICompressProgressInfo.INVALID) {
            outSizeNew = _outStartValue + (outSize);
            outSizeNewPointer = outSizeNew;
        } else
            outSizeNewPointer = ICompressProgressInfo.INVALID;
        return _progress.SetRatioInfo(inSizeNewPointer, outSizeNewPointer);
        
    }
    
}

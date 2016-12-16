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

public class LocalProgress implements ICompressProgressInfo {
    IProgress _progress;
    boolean _inSizeIsMain;
    
    public void Init(IProgress progress, boolean inSizeIsMain) {
        _progress = progress;
        _inSizeIsMain = inSizeIsMain;
    }
    
    public int SetRatioInfo(long inSize, long outSize) {
        return _progress.SetCompleted(_inSizeIsMain ? inSize : outSize);
        
    }
    
}

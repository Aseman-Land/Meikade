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

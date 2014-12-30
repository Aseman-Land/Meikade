package SevenZip.Archive.Common;

import Common.LongVector;

public interface CoderMixer2 {
    
    void ReInit();

    void SetBindInfo(BindInfo bindInfo);

    void SetCoderInfo(int coderIndex,LongVector inSizes, LongVector outSizes);
}

package SevenZip.Archive.SevenZip;

import Common.ObjectVector;

class CoderInfo {
    
    int NumInStreams;
    int NumOutStreams;
    public ObjectVector<AltCoderInfo> AltCoders = new Common.ObjectVector<AltCoderInfo>();
    
    boolean IsSimpleCoder() { return (NumInStreams == 1) && (NumOutStreams == 1); }
    
    public CoderInfo() {
        NumInStreams = 0;
        NumOutStreams = 0;
    }
}

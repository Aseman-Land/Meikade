package SevenZip.Archive.SevenZip;
import Common.RecordVector;
import SevenZip.Archive.Common.BindInfo;


class BindInfoEx extends BindInfo {
    
    RecordVector<MethodID> CoderMethodIDs = new RecordVector<MethodID>();
    
    public void Clear() {
        super.Clear(); // CBindInfo::Clear();
        CoderMethodIDs.clear();
    }
}

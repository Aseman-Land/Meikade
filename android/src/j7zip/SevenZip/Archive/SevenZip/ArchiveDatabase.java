package SevenZip.Archive.SevenZip;

import Common.RecordVector;
import Common.ObjectVector;
import Common.BoolVector;
import Common.IntVector;
import Common.LongVector;

class ArchiveDatabase {
    public LongVector PackSizes = new LongVector();
    public BoolVector PackCRCsDefined = new BoolVector();
    public IntVector PackCRCs = new IntVector();
    public ObjectVector<Folder> Folders = new ObjectVector<Folder>();
    public IntVector NumUnPackStreamsVector = new IntVector();
    public ObjectVector<FileItem> Files = new ObjectVector<FileItem>();
    
    void Clear() {
        PackSizes.clear();
        PackCRCsDefined.clear();
        PackCRCs.clear();
        Folders.clear();
        NumUnPackStreamsVector.clear();
        Files.clear();
    }
}
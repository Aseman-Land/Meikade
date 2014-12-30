package SevenZip.Archive;

public interface IArchiveExtractCallback extends SevenZip.IProgress {
    
    // GetStream OUT: S_OK - OK, S_FALSE - skip this file
    // Updated to include parent_dir argument [GAB, OpenLogic 2013-10-28]
    int GetStream(int index, java.io.OutputStream [] outStream,  int askExtractMode, java.io.File parent_dir) throws java.io.IOException;
    
    int PrepareOperation(int askExtractMode);
    int SetOperationResult(int resultEOperationResult) throws java.io.IOException;
}

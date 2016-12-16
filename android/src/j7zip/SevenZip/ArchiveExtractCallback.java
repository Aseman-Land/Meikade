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

package SevenZip;

import SevenZip.Archive.IArchiveExtractCallback;
import SevenZip.Archive.IInArchive;
import SevenZip.Archive.SevenZip.Handler;
import SevenZip.Archive.SevenZipEntry;



import java.io.File;

public class ArchiveExtractCallback implements IArchiveExtractCallback // , ICryptoGetTextPassword,
{
    
    class OutputStream extends java.io.OutputStream {
        java.io.RandomAccessFile file;
        
        public OutputStream(java.io.RandomAccessFile f) {
            file = f;
        }
        
        public void close()  throws java.io.IOException {
            file.close();
            file = null;
        }
        /*
        public void flush()  throws java.io.IOException {
            file.flush();
        }
         */
        public void write(byte[] b)  throws java.io.IOException {
            file.write(b);
        }
        
        public void write(byte[] b, int off, int len)  throws java.io.IOException {
            file.write(b,off,len);
        }
        
        public void write(int b)  throws java.io.IOException {
            file.write(b);
        }
    }
    
    public int SetTotal(long size) {
        return HRESULT.S_OK;
    }
    
    public int SetCompleted(long completeValue) {
        return HRESULT.S_OK;
    }
    
    public void PrintString(String str) {
        System.out.print(str);
    }
    
    public void PrintNewLine() {
        System.out.println("");
    }
    public int PrepareOperation(int askExtractMode) {
        _extractMode = false;
        switch (askExtractMode) {
            case IInArchive.NExtract_NAskMode_kExtract:
                _extractMode = true;
        };
        switch (askExtractMode) {
            case IInArchive.NExtract_NAskMode_kExtract:
                PrintString("Extracting  ");
                break;
            case IInArchive.NExtract_NAskMode_kTest:
                PrintString("Testing     ");
                break;
            case IInArchive.NExtract_NAskMode_kSkip:
                PrintString("Skipping    ");
                break;
        };
        PrintString(_filePath);
        return HRESULT.S_OK;
    }
    
    public int SetOperationResult(int operationResult) throws java.io.IOException {
        switch(operationResult) {
            case IInArchive.NExtract_NOperationResult_kOK:
                break;
            default:
            {
                NumErrors++;
                PrintString("     ");
                switch(operationResult) {
                    case IInArchive.NExtract_NOperationResult_kUnSupportedMethod:
                        PrintString("Unsupported Method");
                        break;
                    case IInArchive.NExtract_NOperationResult_kCRCError:
                        PrintString("CRC Failed");
                        break;
                    case IInArchive.NExtract_NOperationResult_kDataError:
                        PrintString("Data Error");
                        break;
                    default:
                        PrintString("Unknown Error");
                }
            }
        }
            /*
            if(_outFileStream != null && _processedFileInfo.UTCLastWriteTimeIsDefined)
                _outFileStreamSpec->File.SetLastWriteTime(&_processedFileInfo.UTCLastWriteTime);
             */
        if (_outFileStream != null) _outFileStream.close(); // _outFileStream.Release();
            /*
            if (_extractMode && _processedFileInfo.AttributesAreDefined)
                NFile::NDirectory::MySetFileAttributes(_diskFilePath, _processedFileInfo.Attributes);
             */
        PrintNewLine();
        return HRESULT.S_OK;
    }
    
    java.io.OutputStream _outFileStream;
    
    public int GetStream(int index,
            java.io.OutputStream [] outStream,
            // Updated to pass parent_dir argument [GAB, OpenLogic 2013-10-28]
            int askExtractMode, java.io.File parent_dir) throws java.io.IOException {
        
        outStream[0] = null;
        
        SevenZipEntry item = _archiveHandler.getEntry(index);
        _filePath = item.getName();
        
        // Updated to create the extracted file under the parent_dir directory [GAB, OpenLogic 2013-10-28]
        File file = new File(parent_dir, _filePath);
        
        switch (askExtractMode) {
            case IInArchive.NExtract_NAskMode_kTest:
                return HRESULT.S_OK;
                
            case IInArchive.NExtract_NAskMode_kExtract:
                
                try {
                    isDirectory = item.isDirectory();
                    
                    if (isDirectory) {
                        if (file.isDirectory()) {
                            return HRESULT.S_OK;
                        }
                        if (file.mkdirs())
                            return HRESULT.S_OK;
                        else
                            return HRESULT.S_FALSE;
                    }
                    
                    
                    File dirs = file.getParentFile();
                    if (dirs != null) {
                        if (!dirs.isDirectory())
                            if (!dirs.mkdirs())
                                return HRESULT.S_FALSE;
                    }
                    
                    long pos = item.getPosition();
                    if (pos == -1) {
                        file.delete();
                    }
                    
                    // Write the extracted contents to the file under the parent_dir directory [GAB, OpenLogic 2013-10-28]
                    java.io.RandomAccessFile outStr = new java.io.RandomAccessFile(file,"rw");
                    
                    if (pos != -1) {
                        outStr.seek(pos);
                    }
                    
                    outStream[0] = new OutputStream(outStr);
                } catch (java.io.IOException e) {
                    return HRESULT.S_FALSE;
                }
                
                return HRESULT.S_OK;
                
        }
        
        // other case : skip ...
        
        return HRESULT.S_OK;
        
    }
    
    SevenZip.Archive.IInArchive _archiveHandler;  // IInArchive
    String _filePath;       // name inside arcvhive
    String _diskFilePath;   // full path to file on disk
    
    public long NumErrors;
    boolean PasswordIsDefined;
    String Password;
    boolean _extractMode;
    
    boolean isDirectory;
    
    public ArchiveExtractCallback() { PasswordIsDefined = false; }
    
    
    public void Init(SevenZip.Archive.IInArchive archiveHandler) {
        NumErrors = 0;
        _archiveHandler = archiveHandler;
    }
    
}

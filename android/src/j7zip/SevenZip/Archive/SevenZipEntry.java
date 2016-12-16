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

package SevenZip.Archive;

public class SevenZipEntry {
    
    long LastWriteTime;
    
    long UnPackSize;
    long PackSize;
    
    int Attributes;
    long FileCRC;
    
    boolean IsDirectory;
    
    String Name;
    String Methods;
    
    long Position;
    
    public SevenZipEntry(
            String name,
            long packSize,
            long unPackSize,
            long crc,
            long lastWriteTime,
            long position,
            boolean isDir,
            int att,
            String methods) {
        
        this.Name = name;
        this.PackSize = packSize;
        this.UnPackSize = unPackSize;
        this.FileCRC = crc;
        this.LastWriteTime = lastWriteTime;
        this.Position = position;
        this.IsDirectory = isDir;
        this.Attributes = att;
        this.Methods = methods;
    }
    
    public long getCompressedSize() {
        return PackSize;
    }
    
    public long getSize() {
        return UnPackSize;
    }
    
    public long getCrc() {
        return FileCRC;
    }
    
    public String getName() {
        return Name;
    }
    
    public long getTime() {
        return LastWriteTime;
    }
    
    public long getPosition() {
        return Position;
    }
    
    public boolean isDirectory() {
        return IsDirectory;
    }
    
    static final String kEmptyAttributeChar = ".";
    static final String kDirectoryAttributeChar = "D";
    static final String kReadonlyAttributeChar  = "R";
    static final String kHiddenAttributeChar    = "H";
    static final String kSystemAttributeChar    = "S";
    static final String kArchiveAttributeChar   = "A";
    static public final int FILE_ATTRIBUTE_READONLY =            0x00000001  ;
    static public final int FILE_ATTRIBUTE_HIDDEN    =           0x00000002  ;
    static public final int FILE_ATTRIBUTE_SYSTEM    =           0x00000004  ;
    static public final int FILE_ATTRIBUTE_DIRECTORY = 0x00000010;
    static public final int FILE_ATTRIBUTE_ARCHIVE  =            0x00000020  ;
    
    public String getAttributesString() {
        String ret = "";
        ret += ((Attributes & FILE_ATTRIBUTE_DIRECTORY) != 0 || IsDirectory) ?
            kDirectoryAttributeChar: kEmptyAttributeChar;
        ret += ((Attributes & FILE_ATTRIBUTE_READONLY) != 0)?
            kReadonlyAttributeChar: kEmptyAttributeChar;
        ret += ((Attributes & FILE_ATTRIBUTE_HIDDEN) != 0) ?
            kHiddenAttributeChar: kEmptyAttributeChar;
        ret += ((Attributes & FILE_ATTRIBUTE_SYSTEM) != 0) ?
            kSystemAttributeChar: kEmptyAttributeChar;
        ret += ((Attributes & FILE_ATTRIBUTE_ARCHIVE) != 0) ?
            kArchiveAttributeChar: kEmptyAttributeChar;
        return ret;
    }
    
    public String getMethods() {
        return Methods;
    }
}

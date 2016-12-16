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

package SevenZip.Archive.SevenZip;

public class FileItem {
    
    public long CreationTime;
    public long LastWriteTime;
    public long LastAccessTime;
    
    public long UnPackSize;
    public long StartPos;
    public int Attributes;
    public int FileCRC;
    
    public boolean IsDirectory;
    public boolean IsAnti;
    public boolean IsFileCRCDefined;
    public boolean AreAttributesDefined;
    public boolean HasStream;
    // public boolean IsCreationTimeDefined; replace by (CreationTime != 0)
    // public boolean IsLastWriteTimeDefined; replace by (LastWriteTime != 0)
    // public boolean IsLastAccessTimeDefined; replace by (LastAccessTime != 0)
    public boolean IsStartPosDefined;
    public String name;
    
    public FileItem() {
        HasStream = true;
        IsDirectory = false;
        IsAnti = false;
        IsFileCRCDefined = false;
        AreAttributesDefined = false;
        CreationTime = 0; // IsCreationTimeDefined = false;
        LastWriteTime = 0; // IsLastWriteTimeDefined = false;
        LastAccessTime = 0; // IsLastAccessTimeDefined = false;
        IsStartPosDefined = false;
    }
}

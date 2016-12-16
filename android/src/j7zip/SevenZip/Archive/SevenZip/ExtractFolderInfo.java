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

import java.io.IOException;

import Common.BoolVector;
import SevenZip.Archive.Common.BindPair;

class ExtractFolderInfo {
  /* #ifdef _7Z_VOL
     int VolumeIndex;
  #endif */
  public int FileIndex;
  public int FolderIndex;
  public BoolVector ExtractStatuses = new BoolVector();
  public long UnPackSize;
  public ExtractFolderInfo(
    /* #ifdef _7Z_VOL
    int volumeIndex, 
    #endif */
    int fileIndex, int folderIndex)  // CNum fileIndex, CNum folderIndex
  {
    /* #ifdef _7Z_VOL
    VolumeIndex(volumeIndex),
    #endif */
    FileIndex = fileIndex;
    FolderIndex = folderIndex;
    UnPackSize = 0;

    if (fileIndex != InArchive.kNumNoIndex)
    {
      ExtractStatuses.Reserve(1);
      ExtractStatuses.add(true);
    }
  }
}

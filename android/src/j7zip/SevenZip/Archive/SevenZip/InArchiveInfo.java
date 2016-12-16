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

import Common.LongVector;

class InArchiveInfo
{
    public byte ArchiveVersion_Major;
    public byte ArchiveVersion_Minor;
    
    public long StartPosition;
    public long StartPositionAfterHeader;
    public long DataStartPosition;
    public long DataStartPosition2;    
    LongVector FileInfoPopIDs = new LongVector();
    
    void Clear()
    {
        FileInfoPopIDs.clear();
    }    
}

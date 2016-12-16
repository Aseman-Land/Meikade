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

public interface IArchiveExtractCallback extends SevenZip.IProgress {
    
    // GetStream OUT: S_OK - OK, S_FALSE - skip this file
    // Updated to include parent_dir argument [GAB, OpenLogic 2013-10-28]
    int GetStream(int index, java.io.OutputStream [] outStream,  int askExtractMode, java.io.File parent_dir) throws java.io.IOException;
    
    int PrepareOperation(int askExtractMode);
    int SetOperationResult(int resultEOperationResult) throws java.io.IOException;
}

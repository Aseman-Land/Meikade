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

import Common.ByteBuffer;
import SevenZip.HRESULT;
import Common.RecordVector;
import Common.ObjectVector;

class StreamSwitch {
    InArchive _archive;
    boolean _needRemove;

    public StreamSwitch() {
        _needRemove = false;
    }
    
    public void close() {
        Remove();
    }
    
    void Remove() {
        if (_needRemove) {
            _archive.DeleteByteStream();
            _needRemove = false;
        }
    }
    
    void Set(InArchive archive, ByteBuffer byteBuffer) {
        Set(archive, byteBuffer.data(), byteBuffer.GetCapacity());
    }
    
    void Set(InArchive archive, byte [] data, int size) {
        Remove();
        _archive = archive;
        _archive.AddByteStream(data, size);
        _needRemove = true;
    }
    
    int Set(InArchive archive, ObjectVector<ByteBuffer> dataVector)   throws java.io.IOException {
        Remove();
        int external = archive.ReadByte();
        if (external != 0) {
            int dataIndex = archive.ReadNum();
            Set(archive, dataVector.get(dataIndex));
        }
        return HRESULT.S_OK;
    }
}

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

package Common;

public class CRC {
    static public int[] Table = new int[256];
    
    static
    {
        for (int i = 0; i < 256; i++) {
            int r = i;
            for (int j = 0; j < 8; j++)
                if ((r & 1) != 0)
                    r = (r >>> 1) ^ 0xEDB88320;
                else
                    r >>>= 1;
            Table[i] = r;
        }
    }
    
    int _value = -1;
    
    public void Init() {
        _value = -1;
    }
    
    public void UpdateByte(int b) {
        _value = Table[(_value ^ b) & 0xFF] ^ (_value >>> 8);
    }
    
    public void UpdateUInt32(int v) {
        for (int i = 0; i < 4; i++)
            UpdateByte((v >> (8 * i)) & 0xFF );
    }
    
    public void UpdateUInt64(long v) {
        for (int i = 0; i < 8; i++)
            UpdateByte((int)((v >> (8 * i))) & 0xFF);
    }
    
    public int GetDigest() {
        return _value ^ (-1);
    }
    
    public void Update(byte[] data, int size) {
        for (int i = 0; i < size; i++)
            _value = Table[(_value ^ data[i]) & 0xFF] ^ (_value >>> 8);
    }
    
    public void Update(byte[] data) {
        for (int i = 0; i < data.length; i++)
            _value = Table[(_value ^ data[i]) & 0xFF] ^ (_value >>> 8);
    }
    
    public void Update(byte[] data, int offset, int size) {
        for (int i = 0; i < size; i++)
            _value = Table[(_value ^ data[offset + i]) & 0xFF] ^ (_value >>> 8);
    }
    
    public static int CalculateDigest(byte [] data, int size) {
        CRC crc = new CRC();
        crc.Update(data, size);
        return crc.GetDigest();
    }
    
    static public boolean VerifyDigest(int digest, byte [] data, int size) {
        return (CalculateDigest(data, size) == digest);
    }
}

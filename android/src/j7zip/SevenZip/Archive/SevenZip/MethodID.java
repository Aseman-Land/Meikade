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
import Common.RecordVector;

class MethodID {
    
    static public final MethodID k_LZMA      = new MethodID(0x3, 0x1, 0x1);
    static public final MethodID k_PPMD      = new MethodID(0x3, 0x4, 0x1);
    static public final MethodID k_BCJ_X86   = new MethodID(0x3, 0x3, 0x1, 0x3);
    static public final MethodID k_BCJ       = new MethodID(0x3, 0x3, 0x1, 0x3);
    static public final MethodID k_BCJ2      = new MethodID(0x3, 0x3, 0x1, 0x1B);
    static public final MethodID k_Deflate   = new MethodID(0x4, 0x1, 0x8);
    static public final MethodID k_Deflate64 = new MethodID(0x4, 0x1, 0x9);
    static public final MethodID k_BZip2     = new MethodID(0x4, 0x2, 0x2);
    static public final MethodID k_Copy      = new MethodID(0x0);
    static public final MethodID k_7zAES     = new MethodID(0x6, 0xF1, 0x07, 0x01);
    
    static final int kMethodIDSize = 15;
    byte [] ID;
    byte IDSize;
    
    public MethodID() {
        ID = new byte[kMethodIDSize];
        IDSize = 0;
    }
 
    public MethodID(int a) {
        int size = 1;
        ID = new byte[size];
        IDSize = (byte)size;
        ID[0] = (byte)a;
    } 
        
    public MethodID(int a, int b ,int c) {
        int size = 3;
        ID = new byte[size];
        IDSize = (byte)size;
        ID[0] = (byte)a;
        ID[1] = (byte)b;
        ID[2] = (byte)c;
    }    
 
    public MethodID(int a, int b ,int c, int d) {
        int size = 4;
        ID = new byte[size];
        IDSize = (byte)size;
        ID[0] = (byte)a;
        ID[1] = (byte)b;
        ID[2] = (byte)c;
        ID[3] = (byte)d;
    } 
        
    public boolean equals(MethodID anObject) {
        if (IDSize != anObject.IDSize) return false;
        
        for(int i = 0; i < IDSize ; i++) {
            if (ID[i] != anObject.ID[i]) return false;
        }
        
        return true;
    }
}

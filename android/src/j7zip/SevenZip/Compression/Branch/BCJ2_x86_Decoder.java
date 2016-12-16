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

package SevenZip.Compression.Branch;

import java.io.IOException;
import java.io.PrintStream;

import SevenZip.ICompressCoder2;
import SevenZip.ICompressProgressInfo;
import SevenZip.HRESULT;
import SevenZip.Common.InBuffer;
import Common.RecordVector;
import SevenZip.Compression.LZ.OutWindow;

public class BCJ2_x86_Decoder implements ICompressCoder2 {

    public static final int kNumMoveBits = 5;
    
    InBuffer _mainInStream = new InBuffer();
    InBuffer _callStream = new InBuffer();
    InBuffer _jumpStream = new InBuffer();
    
    SevenZip.Compression.RangeCoder.BitDecoder _statusE8Decoder[] = new SevenZip.Compression.RangeCoder.BitDecoder[256];
    SevenZip.Compression.RangeCoder.BitDecoder _statusE9Decoder = new SevenZip.Compression.RangeCoder.BitDecoder(kNumMoveBits);
    SevenZip.Compression.RangeCoder.BitDecoder _statusJccDecoder = new SevenZip.Compression.RangeCoder.BitDecoder(kNumMoveBits);
    
    OutWindow _outStream = new OutWindow();
    SevenZip.Compression.RangeCoder.Decoder _rangeDecoder = new SevenZip.Compression.RangeCoder.Decoder();
    
    
    // static final boolean IsJcc(int b0, int b1) {
    //     return ((b0 == 0x0F) && ((b1 & 0xF0) == 0x80));
    // }
    
    int CodeReal(
            RecordVector<java.io.InputStream>  inStreams,
            Object useless1, // const UInt64 ** /* inSizes */,
            int numInStreams,
            RecordVector<java.io.OutputStream> outStreams,
            Object useless2, // const UInt64 ** /* outSizes */,
            int numOutStreams,
            ICompressProgressInfo progress) throws java.io.IOException {
        
        if (numInStreams != 4 || numOutStreams != 1)
            return HRESULT.E_INVALIDARG;
        
        _mainInStream.Create(1 << 16);
        _callStream.Create(1 << 20);
        _jumpStream.Create(1 << 16);
        _rangeDecoder.Create(1 << 20);
        _outStream.Create(1 << 16);
        
        _mainInStream.SetStream(inStreams.get(0));
        _callStream.SetStream(inStreams.get(1));
        _jumpStream.SetStream(inStreams.get(2));
        _rangeDecoder.SetStream(inStreams.get(3));
        _outStream.SetStream(outStreams.get(0));
        
        _mainInStream.Init();
        _callStream.Init();
        _jumpStream.Init();
        _rangeDecoder.Init();
        _outStream.Init();
        
        for (int i = 0; i < 256; i++) {
            _statusE8Decoder[i] = new SevenZip.Compression.RangeCoder.BitDecoder(kNumMoveBits);
            _statusE8Decoder[i].Init();
        }
        _statusE9Decoder.Init();
        _statusJccDecoder.Init();
        
        int prevByte = 0;
        int processedBytes = 0;
        for (;;) {
            
            if (processedBytes > (1 << 20) && progress != null) {
                long nowPos64 = _outStream.GetProcessedSize();
                int res = progress.SetRatioInfo(ICompressProgressInfo.INVALID, nowPos64);
                if (res != HRESULT.S_OK) return res;
                
                processedBytes = 0;
            }
            
            processedBytes++;
            int b = _mainInStream.read();
            if (b == -1)
                return Flush();
            _outStream.WriteByte(b); // System.out.println("0:"+b);
            // if ((b != 0xE8) && (b != 0xE9) && (!IsJcc(prevByte, b))) {
            if ((b != 0xE8) && (b != 0xE9) && (!((prevByte == 0x0F) && ((b & 0xF0) == 0x80)))) {
                prevByte = b;
                continue;
            }
            
            boolean status;
            if (b == 0xE8)
                status = (_statusE8Decoder[prevByte].Decode(_rangeDecoder) == 1);
            else if (b == 0xE9)
                status = (_statusE9Decoder.Decode(_rangeDecoder) == 1);
            else
                status = (_statusJccDecoder.Decode(_rangeDecoder) == 1);
            
            if (status) {
                int src;
                if (b == 0xE8) {
                    int b0 = _callStream.read();
                    // if(b0 == -1) return HRESULT.S_FALSE;
                    src = ((int)b0) << 24;
                    
                    b0 = _callStream.read();
                    // if(b0 == -1) return HRESULT.S_FALSE;
                    src |= ((int)b0) << 16;
                    
                    b0 = _callStream.read();
                    // if(b0 == -1) return HRESULT.S_FALSE;
                    src |= ((int)b0) << 8;
                    
                    b0 = _callStream.read();
                    if(b0 == -1) return HRESULT.S_FALSE;
                    src |= ((int)b0);
                    
                } else {
                    int b0 = _jumpStream.read();
                    // if(b0 == -1) return HRESULT.S_FALSE;
                    src = ((int)b0) << 24;
                    
                    b0 = _jumpStream.read();
                    // if(b0 == -1) return HRESULT.S_FALSE;
                    src |= ((int)b0) << 16;
                    
                    b0 = _jumpStream.read();
                    // if(b0 == -1) return HRESULT.S_FALSE;
                    src |= ((int)b0) << 8;
                    
                    b0 = _jumpStream.read();
                    if(b0 == -1) return HRESULT.S_FALSE;
                    src |= ((int)b0);
                    
                }
                int dest = src - ((int)_outStream.GetProcessedSize() + 4) ;
                _outStream.WriteByte(dest);
                _outStream.WriteByte((dest >> 8));
                _outStream.WriteByte((dest >> 16));
                _outStream.WriteByte((dest >> 24));
                prevByte = (int)(dest >> 24) & 0xFF;
                processedBytes += 4;
            } else
                prevByte = b;
        }
    }
    
    public int Flush() throws java.io.IOException {
        _outStream.Flush();
        return HRESULT.S_OK;
    }
    
    public int Code(
            RecordVector<java.io.InputStream>  inStreams, // ISequentialInStream **inStreams,
            Object useless_inSizes, // const UInt64 ** /* inSizes */,
            int numInStreams,
            RecordVector<java.io.OutputStream> outStreams, // ISequentialOutStream **outStreams
            Object useless_outSizes, // const UInt64 ** /* outSizes */,
            int numOutStreams,
            ICompressProgressInfo progress) throws java.io.IOException {
        
        try {
            return CodeReal(inStreams, useless_inSizes, numInStreams,
                    outStreams, useless_outSizes,numOutStreams, progress);
        } catch(java.io.IOException e) {
            throw e;
        } finally {
            ReleaseStreams();
        }
    }
    
    void ReleaseStreams() throws java.io.IOException {
        _mainInStream.ReleaseStream();
        _callStream.ReleaseStream();
        _jumpStream.ReleaseStream();
        _rangeDecoder.ReleaseStream();
        _outStream.ReleaseStream();
    }
    
    public void close() throws java.io.IOException {
        ReleaseStreams();       
    }
    
}

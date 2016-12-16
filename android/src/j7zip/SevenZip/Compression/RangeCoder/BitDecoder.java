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

package SevenZip.Compression.RangeCoder;


public class BitDecoder extends BitModel
{
    public BitDecoder(int num) {
        super(num);
    }
  public int Decode(Decoder decoder)  throws java.io.IOException
  {
    int newBound = (decoder.Range >>> kNumBitModelTotalBits) * this.Prob;
    if ((decoder.Code ^ 0x80000000) < (newBound ^ 0x80000000))
    {
      decoder.Range = newBound;
      this.Prob += (kBitModelTotal - this.Prob) >>> numMoveBits;
      if ((decoder.Range & kTopMask) == 0)
      {
        decoder.Code = (decoder.Code << 8) | decoder.bufferedStream.read();
        decoder.Range <<= 8;
      }
      return 0;
    }
    else
    {
      decoder.Range -= newBound;
      decoder.Code -= newBound;
      this.Prob -= (this.Prob) >>> numMoveBits;
      if ((decoder.Range & kTopMask) == 0)
      {
        decoder.Code = (decoder.Code << 8) | decoder.bufferedStream.read();
        decoder.Range <<= 8;
      }
      return 1;
    }
  }
}

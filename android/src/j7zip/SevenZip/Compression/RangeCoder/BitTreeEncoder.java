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
import java.io.IOException;

public class BitTreeEncoder
{
	short[] Models;
	int NumBitLevels;
	
	public BitTreeEncoder(int numBitLevels)
	{
		NumBitLevels = numBitLevels;
		Models = new short[1 << numBitLevels];
	}
	
	public void Init()
	{
		Decoder.InitBitModels(Models);
	}
	
	public void Encode(Encoder rangeEncoder, int symbol) throws IOException
	{
		int m = 1;
		for (int bitIndex = NumBitLevels; bitIndex != 0; )
		{
			bitIndex--;
			int bit = (symbol >>> bitIndex) & 1;
			rangeEncoder.Encode(Models, m, bit);
			m = (m << 1) | bit;
		}
	}
	
	public void ReverseEncode(Encoder rangeEncoder, int symbol) throws IOException
	{
		int m = 1;
		for (int  i = 0; i < NumBitLevels; i++)
		{
			int bit = symbol & 1;
			rangeEncoder.Encode(Models, m, bit);
			m = (m << 1) | bit;
			symbol >>= 1;
		}
	}
	
	public int GetPrice(int symbol)
	{
		int price = 0;
		int m = 1;
		for (int bitIndex = NumBitLevels; bitIndex != 0; )
		{
			bitIndex--;
			int bit = (symbol >>> bitIndex) & 1;
			price += Encoder.GetPrice(Models[m], bit);
			m = (m << 1) + bit;
		}
		return price;
	}
	
	public int ReverseGetPrice(int symbol)
	{
		int price = 0;
		int m = 1;
		for (int i = NumBitLevels; i != 0; i--)
		{
			int bit = symbol & 1;
			symbol >>>= 1;
			price += Encoder.GetPrice(Models[m], bit);
			m = (m << 1) | bit;
		}
		return price;
	}
	
	public static int ReverseGetPrice(short[] Models, int startIndex,
			int NumBitLevels, int symbol)
	{
		int price = 0;
		int m = 1;
		for (int i = NumBitLevels; i != 0; i--)
		{
			int bit = symbol & 1;
			symbol >>>= 1;
			price += Encoder.GetPrice(Models[startIndex + m], bit);
			m = (m << 1) | bit;
		}
		return price;
	}
	
	public static void ReverseEncode(short[] Models, int startIndex,
			Encoder rangeEncoder, int NumBitLevels, int symbol) throws IOException
	{
		int m = 1;
		for (int i = 0; i < NumBitLevels; i++)
		{
			int bit = symbol & 1;
			rangeEncoder.Encode(Models, startIndex + m, bit);
			m = (m << 1) | bit;
			symbol >>= 1;
		}
	}
}

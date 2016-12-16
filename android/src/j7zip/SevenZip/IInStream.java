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

package SevenZip;

public abstract class IInStream extends java.io.InputStream
{
  static public final int STREAM_SEEK_SET	= 0;
  static public final int STREAM_SEEK_CUR	= 1;
  // static public final int STREAM_SEEK_END	= 2;
  public abstract long Seek(long offset, int seekOrigin)  throws java.io.IOException ;
}

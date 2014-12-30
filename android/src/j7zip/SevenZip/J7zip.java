package SevenZip;

import SevenZip.Archive.SevenZip.Handler;
import SevenZip.Archive.SevenZipEntry;
import SevenZip.Archive.IArchiveExtractCallback;
import SevenZip.Archive.IInArchive;
import SevenZip.Invalid7zArchiveException;

import java.text.DateFormat;

import java.util.HashMap;
import java.util.Vector;

public class J7zip {
    static void PrintHelp() {
        System.out.println(
                "\nUsage:  JZip <l|t|x> <archive_name> [destination_dir]\n" +
                "  t : Tests archive.7z\n" +
                "  x : eXtracts files\n");
    }
    
    static void listing(IInArchive archive,Vector<String> listOfNames,boolean techMode) {
        
        if (!techMode) {
            System.out.println("  Date   Time   Attr         Size   Compressed  Name");
            System.out.println("-------------- ----- ------------ ------------  ------------");
        }
        
        long size = 0;
        long packSize = 0;
        long nbFiles = 0;
        
        for(int i = 0; i < archive.size() ; i++) {
            SevenZipEntry item = archive.getEntry(i);
            
            DateFormat formatter = DateFormat.getDateTimeInstance(DateFormat.SHORT , DateFormat.SHORT );
            String str_tm = formatter.format(new java.util.Date(item.getTime()));
            
            if (listOfNames.contains(item.getName())) {
                if (techMode) {
                    System.out.println("Path = " + item.getName());
                    System.out.println("Size = " + item.getSize());
                    System.out.println("Packed Size = " + item.getCompressedSize());
                    System.out.println("Modified = " + str_tm);
                    System.out.println("   Attributes : " + item.getAttributesString());
                    long crc = item.getCrc();
                    if (crc != -1)
                        System.out.println("CRC = " + Long.toHexString(crc).toUpperCase());
                    else
                        System.out.println("CRC =");
                    System.out.println("Method = " + item.getMethods() );
                    System.out.println("" );
                    
                } else {
                    System.out.print(str_tm + " " + item.getAttributesString());
                    
                    System.out.print(String.format("%13d",item.getSize()));
                    
                    System.out.print(String.format("%13d",item.getCompressedSize()));
                    
                    System.out.println("  " + item.getName());
                }
                
                size += item.getSize();
                packSize += item.getCompressedSize();
                nbFiles ++;
            }
        }
        
        if (!techMode) {
            System.out.println("-------------- ----- ------------ ------------  ------------");
            System.out.print(String.format("                    %13d%13d %d files",size,packSize,nbFiles));
        }
    }
    
    // Updated to include parent_dir argument [GAB, OpenLogic 2013-10-28]
    static void testOrExtract(IInArchive archive,Vector<String> listOfNames,int mode, String parent_dir) throws Exception {
        
        ArchiveExtractCallback extractCallbackSpec = new ArchiveExtractCallback();
        IArchiveExtractCallback extractCallback = extractCallbackSpec;
        extractCallbackSpec.Init(archive);
        extractCallbackSpec.PasswordIsDefined = false;
        
        try {  
            int len = 0;
            int arrays []  = null;
                            
            int res;
            
            if (len == 0) {
              // Updated to pass parent_dir argument [GAB, OpenLogic 2013-10-28]
                res = archive.Extract(null, -1, mode , extractCallback, parent_dir);
            } else {
              // Updated to pass parent_dir argument [GAB, OpenLogic 2013-10-28]
                res = archive.Extract(arrays, len, mode, extractCallback, parent_dir);
            }
            
            if (res == HRESULT.S_OK) {
                if (extractCallbackSpec.NumErrors == 0)
                    System.out.println("Ok Done");
                else
                    System.out.println(" " + extractCallbackSpec.NumErrors + " errors");
            } else {
                System.out.println("ERROR !!");
                throw new Invalid7zArchiveException("Invalid 7z archive");
            }
        } catch (java.io.IOException e) {
            System.out.println("IO error : " + e.getLocalizedMessage());
        }
    }
    
    public static void main(String[] args) throws Exception {
      // Added parent_dir to store destination directory [GAB, OpenLogic 2013-10-28]
        String parent_dir;
        System.out.println("\nJ7zip 4.43 ALPHA 2 (" + Runtime.getRuntime().availableProcessors() + " CPUs)");
        
        if (args.length < 2) {
            PrintHelp();
            return ;
        }
        
        // if the user has passed in a destination directory where
        // the extracted file should be written, use that,
        // otherwise use the current working directory
        if (args.length == 3) {
            parent_dir = args[2];
        }
        else {
            parent_dir = System.getProperty("user.dir");
        }
        
        final int MODE_LISTING = 0;
        final int MODE_TESTING = 1;
        final int MODE_EXTRACT = 2;
        
        int mode = -1;
        
        // this was used to pick out specific files to compress or extract
        // I'm not using it for our extraction-only tool, but it was too much
        // of a pain to remove it everywheere so I'm leaving an empty list as
        // a placeholder.
        Vector<String> listOfNames = new Vector<String>();
        
        if (args[0].equals("l")) {
            mode = MODE_LISTING;
        } else if (args[0].equals("t")) {
            mode = MODE_TESTING;
        } else if (args[0].equals("x")) {
            mode = MODE_EXTRACT;
        } else {
            PrintHelp();
            return ;
        }
        
        String filename = args[1];
        
        MyRandomAccessFile istream = new MyRandomAccessFile(filename,"r");
        
        IInArchive archive = new Handler();
        
        int ret = archive.Open( istream );
        
        if (ret != 0) {
            // System.out.println("ERROR !");
            throw new Invalid7zArchiveException("Invalid 7z archive");
            // return ;
        }
        
        switch(mode) {
            case MODE_LISTING:
                listing(archive,listOfNames,false);
                break;
            case MODE_TESTING:
                // Updated to include parent_dir argument [GAB, OpenLogic 2013-10-28]
                testOrExtract(archive,listOfNames,IInArchive.NExtract_NAskMode_kTest, parent_dir);
                break;
            case MODE_EXTRACT:
                // Updated to include parent_dir argument [GAB, OpenLogic 2013-10-28]
                testOrExtract(archive,listOfNames,IInArchive.NExtract_NAskMode_kExtract, parent_dir);
                break;
        }
        
        archive.close();
    }

    boolean extract(String archive, String target)
    {
        String[] args = new String[3];
        args[0] = "x";
        args[1] = archive;
        args[2] = target;
        try {
            main(args);
        } catch(Exception e) {
            return false;
        }
        return true;
    }
}

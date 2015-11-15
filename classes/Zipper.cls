public class Zipper 
{

private Map<String,fileObject> zipFileMap = new Map<String, fileObject>{};


// Local File Header
final static String LFHSignature = '504b0304';      


// Central Directory 
final static String CFHSignature = '504b0102';  // little Endian Central file header signature


// End of Central Directory records
final String endCentralDirSignature ='504b0506'; //Little Endian formatted signature (4 bytes)
final String numberOfThisDisk = '0000'; // (2 bytes)
final String numberOfTheDiskWithStartCentralDir = '0000'; //(2 bytes)
private String totalNumberOfEntriesInTheCentralDirOnThisDisk =  '0000' ;//(2 bytes)
private String totalNumberOfEntriesCentralDir  = '0000'; //(2 bytes)
private String sizeOfCentralDir  = '00000000'; //(4 bytes)
private String offsetOfStartOfCentralDir = '00000000'; //(4 bytes)
final String zipfileCommentLength = '0000';  //(this is c), (2 bytes)
final String zipfileComment = '00'; // (c bytes)


private String getEndOfCentralDir ()
{
return endCentralDirSignature + numberOfThisDisk + numberOfTheDiskWithStartCentralDir + totalNumberOfEntriesInTheCentralDirOnThisDisk +
        totalNumberOfEntriesCentralDir  + sizeOfCentralDir + offsetOfStartOfCentralDir +
        zipfileCommentLength + zipfileComment;
}


public Blob getZipFile ()
{
String zipFileBuffer ='';
Integer zipFileSize = 0;
for (fileObject tempFileObject : zipFileMap.values())
{
    tempFileObject.OffsetOfLH = returnLEHexStringOfDecimal(zipfileSize, 4);
    zipFileBuffer += tempFileObject.getLocalFileHeader();
    zipfileSize = zipFileBuffer.length()/2;
    tempFileObject.fileData = null;
}
offsetOfStartOfCentralDir = returnLEHexStringOfDecimal(zipfileSize,4);
for (fileObject tempFileObject : zipFileMap.values())
{
    zipFileBuffer += tempFileObject.getCentralFileHeader();
}
sizeOfCentralDir = returnLEHexStringOfDecimal(zipFileBuffer.length()/2 - zipfileSize,4);
totalNumberOfEntriesInTheCentralDirOnThisDisk = returnLEHexStringOfDecimal(zipFileMap.size(),2);
totalNumberOfEntriesCentralDir = returnLEHexStringOfDecimal(zipFileMap.size(),2);

zipFileBuffer += getEndOfCentralDir();

zipFileMap.clear();

return EncodingUtil.convertFromHex(zipFileBuffer);
}

public void addFileToZip (String fileName, Blob fileData, String crc32)
{
    fileObject tempFileObject = new fileObject();
    
    
    tempFileObject.lastModTime = '1c7d';// (2 bytes) - sample value is  15:40:56 
    tempFileObject.lastModDate = '4b35';// (2 bytes) - sample value is  10/11/2006 
    
    //if (String.isBlank(crc32)) {
    //    tempFileObject.crc32 = HexUtil.intToHex(HexUtil.CRC32Table(fileData),4);// (4 bytes) 
    //} else {
        tempFileObject.crc32 = crc32;
    //}//////

    tempFileObject.uncompressedSize = returnLEHexStringOfDecimal(fileData.size(), 4);// (4 bytes) 
    tempFileObject.compressedSize = tempFileObject.uncompressedSize;// (4 bytes), creates (n)

    tempFileObject.fileNameLength = returnLEHexStringOfDecimal(fileName.length(), 2);// (2 bytes), creates (f)

    //tempFileObject.extraFieldLength = '1C00';// (2 bytes) , creates (e)
    tempFileObject.extraFieldLength = '0000';// (2 bytes) , creates (e)
    tempFileObject.fileCommentLength = '0000';// (2 bytes), creates (c)
    tempFileObject.diskNumStart = '0000';// (2 bytes) 
    tempFileObject.internalFileAtt = '0000';// (2 bytes) //Internal file attributes
    tempFileObject.externalFileAtt = '0000A481';// (4 bytes) //External file attributes

    tempFileObject.fileName = EncodingUtil.convertToHex(Blob.valueOf(fileName));// (f bytes) // from the parameters passed


  // tempFileObject.extraField = '5554090003CD16C3544017C35475780B000104F60100000414000000';// (e bytes) 
  tempFileObject.extraField = '';
   // tempFileObject.fileComment = '00';// (c bytes) 
   tempFileObject.fileComment = '';// (c bytes) 

    tempFileObject.fileData = EncodingUtil.convertToHex(fileData); // (n bytes) // from the parameters passed
    
    
    
    zipFileMap.put(fileName, tempFileObject);  //add the new subFile to the Zip List
}

public String returnLEHexStringOfDecimal (Integer decimalNumber, Integer sizeInBytes)
{
String LEHexStringOfDecimal = '';
Integer remainder = 0;
Integer byteLocation = 0;
String tempRightDigit ='0';
String tempLeftDigit ='0';
while (decimalnumber > 0)
{
    remainder = math.mod(decimalnumber, 16);
    decimalnumber = decimalnumber / 16;
    if (remainder == 1) tempRightDigit = '1';
    if (remainder == 2) tempRightDigit = '2';
    if (remainder == 3) tempRightDigit = '3';
    if (remainder == 4) tempRightDigit = '4';
    if (remainder == 5) tempRightDigit = '5';
    if (remainder == 6) tempRightDigit = '6';
    if (remainder == 7) tempRightDigit = '7';
    if (remainder == 8) tempRightDigit = '8';
    if (remainder == 9) tempRightDigit = '9';
    if (remainder == 10) tempRightDigit = 'A';
    if (remainder == 11) tempRightDigit = 'B';
    if (remainder == 12) tempRightDigit = 'C';
    if (remainder == 13) tempRightDigit = 'D';
    if (remainder == 14) tempRightDigit = 'E';
    if (remainder == 15) tempRightDigit = 'F';
    
    if (remainder == 0)  tempRightDigit = '0';
            remainder = math.mod(decimalnumber, 16);
            decimalnumber = decimalnumber / 16;
                if (remainder == 0) tempLeftDigit = '0';
                if (remainder == 1) tempLeftDigit = '1';
                if (remainder == 2) tempLeftDigit = '2';
                if (remainder == 3) tempLeftDigit = '3';
                if (remainder == 4) tempLeftDigit = '4';
                if (remainder == 5) tempLeftDigit = '5';
                if (remainder == 6) tempLeftDigit = '6';
                if (remainder == 7) tempLeftDigit = '7';
                if (remainder == 8) tempLeftDigit = '8';
                if (remainder == 9) tempLeftDigit = '9';
                if (remainder == 10) tempLeftDigit = 'A';
                if (remainder == 11) tempLeftDigit = 'B';
                if (remainder == 12) tempLeftDigit = 'C';
                if (remainder == 13) tempLeftDigit = 'D';
                if (remainder == 14) tempLeftDigit = 'E';
                if (remainder == 15) tempLeftDigit = 'F';
     
     LEHexStringOfDecimal = LEHEXStringOfDecimal + tempLeftDigit + tempRightDigit;
     byteLocation++;
}
for (Integer x = byteLocation; x < sizeInBytes; x++)
    LEHexStringOfDecimal = LEHexStringOfDecimal + '00';

return LEHexStringOfDecimal;
}



public class FileObject
{
// note all strings are hex representations in little endian format
final String creatorVersion = '0A00'; // (2 bytes) likely Windows NT
final String minExtractorVersion = '0A00'; // (2 bytes) likely Windows NT
final String GPFlagBit = '0000';  // (2 bytes) general purpose flag bit
final String compressionMethod = '0000'; // (2 bytes) no compression
private String lastModTime = '0000';// (2 bytes) 
private String lastModDate = '0000';// (2 bytes) 
private String crc32 = null;//'00000000';// (4 bytes) 
private String compressedSize = '01000000';// (4 bytes), creates (n)
private String uncompressedSize = '00000000';// (4 bytes) 
private String fileNameLength = '01000000';// (2 bytes), creates (f)
private String extraFieldLength = '0000';// (2 bytes) , creates (e)
private String fileCommentLength = '0000';// (2 bytes), creates (c)
private String diskNumStart = '0000';// (2 bytes) 
private String internalFileAtt = '0000';// (2 bytes) 
private String externalFileAtt = '00000000';// (4 bytes) 
private String OffsetOfLH = '00000000';// (4 bytes) 
private String fileName = '00';// (f bytes) 
private String extraField = '00';// (e bytes) 
private String fileComment = '00';// (c bytes) 
public String fileData = '00';// (n bytes)

public fileObject(){}

public String getLocalFileHeader()
{
    if (String.isBlank(crc32)) {  
        crc32 = HexUtil.intToHex(HexUtil.CRC32Table(fileData), 4);// (4 bytes) 
    }
    return Zipper.LFHSignature + minExtractorVersion + GPFlagBit + compressionMethod +lastModTime + lastModDate + 
            crc32 + compressedSize + uncompressedSize + fileNameLength + extraFieldLength + fileName + extraField +
            fileData;
}


public String getCentralFileHeader()
{
    if (String.isBlank(crc32)) {
        crc32 = HexUtil.intToHex(HexUtil.CRC32Table(fileData), 4);// (4 bytes) 
    }
    return Zipper.CFHSignature + creatorVersion + minExtractorVersion + GPFlagBit + compressionMethod +lastModTime + lastModDate 
            + crc32 + compressedSize + uncompressedSize + fileNameLength + extraFieldLength
            + fileCommentLength + diskNumStart + internalFileAtt + externalFileAtt + OffsetOfLH + fileName
            + extraField + fileComment;

}


}
// end of fileObject class



}
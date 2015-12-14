@isTest
private class ZipperTests 
{
    @isTest static void testHexUtil() 
    {

        String testData = 'This is a test';  //test data
        Integer predictedCRC32 = (Integer)(3229261618L);
        System.assertEquals(HexUtil.CRC32Table(Blob.valueOf(testData)) , predictedCRC32);
        System.assertEquals(HexUtil.CRC32Table(EncodingUtil.convertToHex(Blob.valueOf(testData))) , predictedCRC32);

        testData = 'test two';
        predictedCRC32 = 1542186603;
        System.assertEquals(HexUtil.CRC32Table(Blob.valueOf(testData)) , predictedCRC32);
        System.assertEquals(HexUtil.CRC32Table(EncodingUtil.convertToHex(Blob.valueOf(testData))) , predictedCRC32);

        testData = '';
        predictedCRC32 = 0;
        System.assertEquals(HexUtil.CRC32Table(Blob.valueOf(testData)) , predictedCRC32);
        System.assertEquals(HexUtil.CRC32Table(EncodingUtil.convertToHex(Blob.valueOf(testData))) , predictedCRC32);

        // public static Integer hexToInt(String hexStr)
        System.assertEquals(HexUtil.hexToInt('ffffffff'),(Integer)(4294967295L));
        System.assertEquals(HexUtil.hexToInt('fffffffe'),(Integer)(4294967294L));
        System.assertEquals(HexUtil.hexToInt('7fffffff'),(Integer)(2147483647 ));
        System.assertEquals(HexUtil.hexToInt('80000000'),(Integer)(2147483648L));
        System.assertEquals(HexUtil.hexToInt('00000000'),(Integer)(0));

        // public static Long hexToLongLE(String hexString)
        System.assertEquals(HexUtil.hexToLongLE('ffffffff'),4294967295L);
        System.assertEquals(HexUtil.hexToLongLE('feffffff'),4294967294L);
        System.assertEquals(HexUtil.hexToLongLE('ffffff7f'),2147483647 );
        System.assertEquals(HexUtil.hexToLongLE('00000080'),2147483648L);
        System.assertEquals(HexUtil.hexToLongLE('00000000'),0);

        // public static String intToHexLE (Integer decNumber, Integer sizeInBytes)
        System.assertEquals(HexUtil.intToHexLE((Integer)(4294967295L),4),'ffffffff');
        System.assertEquals(HexUtil.intToHexLE((Integer)(4294967294L),4),'feffffff');
        System.assertEquals(HexUtil.intToHexLE((Integer)(2147483647 ),4),'ffffff7f');
        System.assertEquals(HexUtil.intToHexLE((Integer)(2147483648L),4),'00000080');
        System.assertEquals(HexUtil.intToHexLE(0,4),'00000000');
        System.assertEquals(HexUtil.intToHexLE(878678,4),'56680d00');
        System.assertEquals(HexUtil.intToHexLE(878678,2),'5668');
        System.assertEquals(HexUtil.intToHexLE(878678,0),'');

    }
    
    @isTest static void zipTest() 
    {
        Blob tinyZip = EncodingUtil.convertFromHex('504B030414000800080096BC7A4700000000000000000000000008001000746578742E74787455580C0055EC5756ECEB5756262ABF22F3C8E40200504B07089A3C22D50500000003000000504B0102150314000800080096BC7A479A3C22D5050000000300000008000C000000000000000040A48100000000746578742E7478745558080055EC5756ECEB5756504B05060000000001000100420000004B0000000000');
        Zipper testZipper = new Zipper(tinyZip);
        System.assertEquals(testZipper.getFileNames(), new Set<String>{'text.txt'});
        System.assertEquals(testZipper.getFile('text.txt').toString(), 'Hi\n');
        
        testZipper.addFileToZip('newDir/added.txt',Blob.valueOf('new data\n'), null);
        System.assertEquals(testZipper.getFileNames(), new Set<String>{'text.txt','newDir/added.txt'});
        System.assertEquals(testZipper.getFile('newDir/added.txt').toString(), 'new data\n');
        
        testZipper.renameFile('text.txt','newDir/changedName.txt');
        System.assertEquals(testZipper.getFileNames(), new Set<String>{'newDir/changedName.txt','newDir/added.txt'});
        
        testZipper.removePrefix('newDir/');
        System.assertEquals(testZipper.getFileNames(), new Set<String>{'changedName.txt','added.txt'});

        testZipper.addFileToZip('added.txt',Blob.valueOf('even newer data\n'), null);
        System.assertEquals(testZipper.getFileNames(), new Set<String>{'changedName.txt','added.txt'});
        System.assertEquals(testZipper.getFile('added.txt').toString(), 'even newer data\n');
        
        testZipper.removeFileFromZip('notHere.txt');
        System.assertEquals(testZipper.getFileNames(), new Set<String>{'changedName.txt','added.txt'});

        testZipper.addFileToZip('secondAdd.txt',Blob.valueOf('important\n'), null);
        testZipper.addFileToZip('thirdAdd.txt',Blob.valueOf('less important\n'), null);
        testZipper.removeFileFromZip('changedName.txt');
        System.assertEquals(testZipper.getFileNames(), new Set<String>{'added.txt','secondAdd.txt', 'thirdAdd.txt'});

        Blob newTinyZip = testZipper.getZipFile();
        Zipper newTestZipper = new Zipper(newTinyZip);
        System.assertEquals(newTestZipper.getFileNames(), new Set<String>{'added.txt','secondAdd.txt', 'thirdAdd.txt'});
        System.assertEquals(testZipper.getFile('added.txt').toString(), 'even newer data\n');
        
        newTestZipper.removeFileFromZip('added.txt');
        System.assertEquals(newTestZipper.getFileNames(), new Set<String>{'secondAdd.txt', 'thirdAdd.txt'});

        //public    Zipper()
        //public    Zipper(Blob fileData)

        //public    void addFileToZip(String fileName, Blob fileData, String crc32)

        //private   static Integer getCurrentDate()
        //private   static Integer getCurrentTime()
        //public    Blob getFile(String fileName)
        //public    Set getFileNames()
        //public    Blob getZipFile()
        //private   void recalculateCentralDirOffsets(Integer offset, Integer delta)
        //public    void removeFileFromZip(String fileName)
        //public    void removePrefix(String prefix)
        //public    void renameFile(String oldName, String newName)
        //private   static void unzipAsync(String paramsStr)
        //public    static void unzipAttachment(Id srcAttId, Id destObjId, List fileNames, Boolean async)

    }
}
Copyright (c) 2015 Pedro Dal Col, Pliny Smith


# zipper
Native Apex zip library
for salesforce.com

WORK IN PROGRESS

More info in the coming weeks

Explanation of Zipper.
A native Apex zip/unzip utility for the salesforce.com platform.

###How to install


###How to use / sample code

open an existing zip file or create a new

####Constructors:
####zipper()
instantiates a new empty zipper object (empty zip archive)

####zipper(Blob fileData)
instantiates a new zipper object from an existing zip file

######Parameters:
fileData - a blob containing a valid zip file

######Example:
```Apex
Attachment sampleAttachment = [SELECT Name, Body FROM Attachment WHERE Id='<ID_OF_ATTACHMENT>'];
Zipper sampleZip = new Zipper(sampleAttachment.Body);
```

####addFileToZip(String fileName, Blob fileData, String crc32)
adds a new file to the current zip archive

######Parameters:
fileName - file name including full path.
fileData - Blob containing the file data. 
crc32 - (optional)  must be hex little endian value of the CRC32.  Enter null value for addFileToZip to calculate the CRC32 of the fileData

######Example:
```Apex
Zipper sampleZip = new Zipper();
Blob fileData = Blob.valueOf('Sample text.');
sampleZip.addFileToZip('sampleFolder/test.txt', fileData, null);
Blob zipData = sampleZip.getZipFile();
```


####getFileNames()
returns a set of filenames from the current zip archive

######Example:
```Apex
Attachment sampleAttachment = [SELECT Name, Body FROM Attachment WHERE Id='<ID_OF_ATTACHMENT>'];
Zipper sampleZip = new Zipper(sampleAttachment.Body);
Set <String> fileNames = sampleZip.getFileNames();
for (String fileName : fileNames)
{
	System.debug('file: ' + fileName);
}
```

####getFile(String fileName)
extracts the specified file contents from the current zip archive.  If the file does not exist, returns null.
######Parameters:
fileName - String containing file name including full path
returns Blob of data
######Example:
```Apex
Zipper sampleZip = new Zipper();
sampleZip.addFileToZip('sampleFolder/test.txt', Blob.valueOf('Sample text.'), null);
Blob fileData = sampleZip.getFile('sampleFolder/test.txt');
System.assertEquals ('Sample text.', fileData.toString());
```

####getFileInfo
 public Map<String,String> getFileInfo(String fileName)

######Parameters:
fileName - file name including full path.
returns a Map that contains values for crc32, fileSize, fileName, and fileComment.

######Example:
```Apex
Zipper sampleZip = new Zipper();
sampleZip.addFileToZip('sampleFolder/test.txt', Blob.valueOf('Sample text.'), null);
Map <String, String> fileInfoMap = sampleZip.getFileInfo('sampleFolder/test.txt');
System.assertEquals ('12', fileInfoMap.get('fileSize'));
System.assertEquals ('sampleFolder/test.txt', fileInfoMap.get('fileName'));
```

####getZipFile()
returns a Blob that contains the entire Zip archive
#######Example:
```Apex
Zipper sampleZip = new Zipper();
sampleZip.addFileToZip('sampleFolder/test.txt', Blob.valueOf('Sample text.'), null);
Blob zipData = sampleZip.getZipFile();
```

####removeFileFromZip(String fileName)
Removes a file from the current zip archive.
######Parameters:
fileName - String containing file name to remove from zip archive including full path 
######Example:
```Apex
Zipper sampleZip = new Zipper();
sampleZip.addFileToZip('sampleFolder/file1.txt', Blob.valueOf('Sample text1.'), null);
sampleZip.addFileToZip('sampleFolder/file2.txt', Blob.valueOf('Sample text2.'), null);
System.assert(sampleZip.getFileNames().contains('sampleFolder/file1.txt'));
System.assert(sampleZip.getFileNames().contains('sampleFolder/file2.txt'));
sampleZip.removeFileFromZip('sampleFolder/file1.txt');
System.assert(sampleZip.getFileNames().contains('sampleFolder/file1.txt') == false);
System.assert(sampleZip.getFileNames().contains('sampleFolder/file2.txt'));
```


####renameFile(String oldName, String newName)
Renames a file in the current zip archive.
######Parameters:
```oldName``` - String containing the current file name to be modified
```newName``` - String containing the new name that replaces the current file name.

######Example:
```Apex
Zipper sampleZip = new Zipper();
sampleZip.addFileToZip('sampleFolder/file.txt', Blob.valueOf('Sample text1.'), null);
System.assert(sampleZip.getFileNames().contains('sampleFolder/file.txt'));
sampleZip.renameFile('sampleFolder/file.txt', 'sampleFolder/changedName.txt');
System.assert(sampleZip.getFileNames().contains('sampleFolder/file.txt') == false);
System.assert(sampleZip.getFileNames().contains('sampleFolder/changedName.txt'));
```


####removePrefix(String prefix)
Removes the specified prefix from all file names in the curent Zip archive only if it occurs at the beginning of the file name.
######Parameters:
prefix - the prefix to remove from file names.
######Example:
```Apex
Zipper sampleZip = new Zipper();
sampleZip.addFileToZip('sampleFolder/file.txt', Blob.valueOf('Sample text1.'), null);
System.assert(sampleZip.getFileNames().contains('sampleFolder/file.txt'));
sampleZip.removePrefix('sample');
System.assert(sampleZip.getFileNames().contains('sampleFolder/file.txt') == false);
System.assert(sampleZip.getFileNames().contains('Folder/file.txt'));
```


####unzipAttachment(Id srcAttId, Id destObjId, String[] fileNames, Boolean async)



###FAQ
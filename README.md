Copyright (c) 2015 Pedro Dal Col, Pliny Smith

# Zippex (aka Zipper)
Native Apex Zip utility for the salesforce.com platform.

###Table of Contents
* [How to install](#how-to-install)
* [Constructors](#constructors)
    * [Zippex()](#zippex)
    * [Zippex(fileData)](#zippexfiledata)
* [Public Methods](#public-methods)
    * [addFile(fileName, fileData, crc32)](#addfilefilename-filedata-crc32)
    * [containsFile(fileName)](#containsfilefilename)
    * [getFileNames()](#getfilenames)
    * [getFile(fileName)](#getfilefilename)
  	* [getFileInfo(fileName)](#getfileinfofilename)
    * [getZipArchive()](#getziparchive)
    * [removeFile(fileName)](#removefilefilename)
    * [renameFile(oldName, newName)](#renamefileoldname-newname)
    * [removePrefix(prefix)](#removeprefixprefix)
    * [unzipAttachment(srcAttId, destObjId, fileNames, attemptAsync)](#unzipattachmentsrcattid-destobjid-filenames-attemptasync)


###How to install

####Option 1: Manually save files to SF

Copy and paste from this repository the following four classes into new classes in your Salesforce instance. 

1. HexUtil.cls
2. Puff.cls
3. Zippex.cls
4. ZippexTests.cls 

<!--
####Option 2: Install from Unmanaged Package

Follow this link to install the latest package:
[link]
-->
####Option 2: Use the 'Deploy to Salesforce' button

<a href="https://githubsfdeploy.herokuapp.com?owner=pdalcol&repo=Zippex">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/src/main/webapp/resources/img/deploy.png">
</a>

###How to use

####Constructors:
####Zippex()
```Apex
public Zippex()
```
Instantiates a new empty Zippex object (empty Zip archive).
######Example
```Apex
Zippex sampleZip = new Zippex();
```

####Zippex(fileData)
```Apex
public Zippex(Blob fileData)
```
Instantiates a new Zippex object from an existing Zip file.

######Parameters
Name     | Type       | Description
---------|------------|--------
fileData | Blob       | Data containing a valid Zip file

######Example
```Apex
Attachment sampleAttachment = [SELECT Name, Body FROM Attachment WHERE Id='<ID_OF_ATTACHMENT>'];
Zippex sampleZip = new Zippex(sampleAttachment.Body);
```
####Public Methods:
####addFile(fileName, fileData, crc32)
```Apex
public void addFile(String fileName, Blob fileData, String crc32)
```
Adds a new file to the current Zip archive.

######Parameters
Name     | Type       | Description
---------|------------|--------
fileName | String     | File name including full path
fileData | Blob       | Data containing the file data
crc32    | String     | **(optional)** little endian hex value of the CRC32.  Enter null for addFile to calculate the CRC32 of the fileData

######Example
```Apex
Zippex sampleZip = new Zippex();
Blob fileData = Blob.valueOf('Sample text.');
sampleZip.addFile('sampleFolder/test.txt', fileData, null);
Blob zipData = sampleZip.getZipArchive();
```


####containsFile(fileName)
```Apex
public Boolean containsFile(String fileName)
```
Returns true if the current Zip archive contains the specified file.

######Parameters
Name      | Type       | Description
----------|------------|--------
fileName  | String     | File name including full path
**Return**| Boolean    | Return true if file is in Zip archive
######Example
```Apex
Zippex sampleZip = new Zippex();
sampleZip.addFile('sampleFolder/test.txt', Blob.valueOf('Sample text.'), null);
System.assert(sampleZip.containsFile('sampleFolder/test.txt'));
```


####getFileNames()
```Apex
public Set<String> getFileNames()
```
Returns a set of filenames from the current Zip archive.
######Parameters
Name       | Type              | Description
-----------|-------------------|--------
**Return** | Set&lt;String&gt; | Returns all file names including full path in the current Zip archive
######Example
```Apex
Attachment sampleAttachment = [SELECT Name, Body FROM Attachment WHERE Id='<ID_OF_ATTACHMENT>'];
Zippex sampleZip = new Zippex(sampleAttachment.Body);
Set <String> fileNames = sampleZip.getFileNames();
for (String fileName : fileNames)
{
    System.debug('file: ' + fileName);
}
```

####getFile(fileName)
```Apex
public Blob getFile(String fileName)

```
Extracts the specified file contents from the current Zip archive.  If the file does not exist, returns null.
######Parameters
Name      | Type       | Description
----------|------------|--------
fileName  | String     | File name including full path
**Return**| Blob       | File data
######Example
```Apex
Zippex sampleZip = new Zippex();
sampleZip.addFile('sampleFolder/test.txt', Blob.valueOf('Sample text.'), null);
Blob fileData = sampleZip.getFile('sampleFolder/test.txt');
System.assertEquals ('Sample text.', fileData.toString());
```

####getFileInfo(fileName)
```Apex
public Map<String,String> getFileInfo(String fileName)
```
Returns file metadata (lastModDateTime, crc32, fileSize, fileName, and fileComment).

######Parameters
Name       |    Type                  | Description
-----------|--------------------------|--------
fileName   | String                   | File name including full path
**Return** | Map&lt;String,String&gt; | Contains values for lastModDateTime, crc32, fileSize, fileName, and fileComment

######Example
```Apex
Zippex sampleZip = new Zippex();
sampleZip.addFile('sampleFolder/test.txt', Blob.valueOf('Sample text.'), null);
Map <String, String> fileInfoMap = sampleZip.getFileInfo('sampleFolder/test.txt');
System.assertEquals ('12', fileInfoMap.get('fileSize'));
System.assertEquals ('sampleFolder/test.txt', fileInfoMap.get('fileName'));
```

####getZipArchive()
```Apex
public Blob getZipArchive()
```
Returns a Blob that contains the entire Zip archive.
######Parameters
Name       | Type       | Description
-----------|------------|--------
**Return** | Blob       | Full Zip archive data
######Example
```Apex
Zippex sampleZip = new Zippex();
sampleZip.addFile('sampleFolder/test.txt', Blob.valueOf('Sample text.'), null);
Blob zipData = sampleZip.getZipArchive();
```

####removeFile(fileName)
```Apex
public void removeFile(String fileName)
```
Removes a file from the current Zip archive.
######Parameters
Name     | Type       | Description
---------|------------|--------
fileName | String     | File name to remove from Zip archive including full path
######Example
```Apex
Zippex sampleZip = new Zippex();
sampleZip.addFile('sampleFolder/file1.txt', Blob.valueOf('Sample text1.'), null);
sampleZip.addFile('sampleFolder/file2.txt', Blob.valueOf('Sample text2.'), null);
System.assert(sampleZip.getFileNames().contains('sampleFolder/file1.txt'));
System.assert(sampleZip.getFileNames().contains('sampleFolder/file2.txt'));
sampleZip.removeFile('sampleFolder/file1.txt');
System.assert(sampleZip.getFileNames().contains('sampleFolder/file1.txt') == false);
System.assert(sampleZip.getFileNames().contains('sampleFolder/file2.txt'));
```


####renameFile(oldName, newName)
```Apex
public void renameFile(String oldName, String newName)
```
Renames a file in the current Zip archive.
######Parameters
Name     | Type       | Description
---------|------------|--------
oldName  | String     | The current file name to be modified
newName  | String     | The new name that replaces the current file name

######Example
```Apex
Zippex sampleZip = new Zippex();
sampleZip.addFile('sampleFolder/file.txt', Blob.valueOf('Sample text1.'), null);
System.assert(sampleZip.getFileNames().contains('sampleFolder/file.txt'));
sampleZip.renameFile('sampleFolder/file.txt', 'sampleFolder/changedName.txt');
System.assert(sampleZip.getFileNames().contains('sampleFolder/file.txt') == false);
System.assert(sampleZip.getFileNames().contains('sampleFolder/changedName.txt'));
```


####removePrefix(prefix)
```Apex
public void removePrefix(String prefix)

```
Removes the specified prefix from all file names in the current Zip archive only if it occurs at the beginning of the file name.
######Parameters
Name     | Type       | Description
---------|------------|--------
prefix   | String     | The prefix to remove from file names
######Example
```Apex
Zippex sampleZip = new Zippex();
sampleZip.addFile('sampleFolder/file.txt', Blob.valueOf('Sample text1.'), null);
System.assert(sampleZip.getFileNames().contains('sampleFolder/file.txt'));
sampleZip.removePrefix('sample');
System.assert(sampleZip.getFileNames().contains('sampleFolder/file.txt') == false);
System.assert(sampleZip.getFileNames().contains('Folder/file.txt'));
```


####unzipAttachment(srcAttId, destObjId, fileNames, attemptAsync)
```Apex
public static void unzipAttachment(Id srcAttId, Id destObjId, String[] fileNames, Boolean attemptAsync){

```
######Parameters
Name         | Type       | Description
-------------|------------|--------
srcAttId     | Id         | ID of the attachment to unzip 
destObjId    | Id         | ID of the object to which unzipped files should be attached. If null the ParentId of the Zip archive will be used
fileNames    | String[]   | List containing file names to uncompress.  If null, all files will be uncompressed
attemptAsync | Boolean    | If true, it attempts to unzip files in a future call
######Example
```Apex
Zippex.unzipAttachment('<ID_OF_ATTACHMENT>', null, null, false);
```


<!--###FAQ-->

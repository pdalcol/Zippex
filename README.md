Copyright (c) 2015 Pedro Dal Col, Pliny Smith

# zipper
Native Apex zip utility for the salesforce.com platform.

###How to install

####Option 1: Manually save files to SF

Copy and paste from this repository the following four classes into new classes in your Salesfoce instance. 

1. HexUtil.cls
2. Puff.cls
3. Zipper.cls
4. ZipperTests.cls 

####Option 2: Install from Unmanaged Package

Follow this link to install the latest package:
[link]

####Option 3: Use the 'Deply to Salesforce' button

<a href="https://githubsfdeploy.herokuapp.com?owner=pdalcol&repo=Zipper">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/src/main/webapp/resources/img/deploy.png">
</a>

###How to use

####Constructors:
####zipper()
```Apex
public Zipper()
```
Instantiates a new empty zipper object (empty zip archive).
######Example
```Apex
Zipper sampleZip = new Zipper();
```

####zipper(fileData)
```Apex
public Zipper(Blob fileData)
```
Instantiates a new zipper object from an existing zip file.

######Parameters
Name     | Type       | Description
---------|------------|--------
fileData | Blob       | Data containing a valid zip file

######Example
```Apex
Attachment sampleAttachment = [SELECT Name, Body FROM Attachment WHERE Id='<ID_OF_ATTACHMENT>'];
Zipper sampleZip = new Zipper(sampleAttachment.Body);
```
####Public Methods:
####addFileToZip(fileName, fileData, crc32)
```Apex
public void addFileToZip(String fileName, Blob fileData, String crc32)
```
Adds a new file to the current zip archive.

######Parameters
Name     | Type       | Description
---------|------------|--------
fileName | String     | File name including full path
fileData | Blob       | Data containing the file data
crc32    | String     | **(optional)** little endian hex value of the CRC32.  Enter null for addFileToZip to calculate the CRC32 of the fileData

######Example
```Apex
Zipper sampleZip = new Zipper();
Blob fileData = Blob.valueOf('Sample text.');
sampleZip.addFileToZip('sampleFolder/test.txt', fileData, null);
Blob zipData = sampleZip.getZipFile();
```


####getFileNames()
```Apex
public Set<String> getFileNames()
```
Returns a set of filenames from the current zip archive.
######Parameters
Name       | Type              | Description
-----------|-------------------|--------
**Return** | Set&lt;String&gt; | Returns all file names including full path in the current zip archive
######Example
```Apex
Attachment sampleAttachment = [SELECT Name, Body FROM Attachment WHERE Id='<ID_OF_ATTACHMENT>'];
Zipper sampleZip = new Zipper(sampleAttachment.Body);
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
Extracts the specified file contents from the current zip archive.  If the file does not exist, returns null.
######Parameters
Name      | Type       | Description
----------|------------|--------
fileName  | String     | File name including full path
**Return**| Blob       | File data
######Example
```Apex
Zipper sampleZip = new Zipper();
sampleZip.addFileToZip('sampleFolder/test.txt', Blob.valueOf('Sample text.'), null);
Blob fileData = sampleZip.getFile('sampleFolder/test.txt');
System.assertEquals ('Sample text.', fileData.toString());
```

####getFileInfo(fileName)
```Apex
public Map<String,String> getFileInfo(String fileName)
```
Returns file metadata (crc32, fileSize, fileName, and fileComment).

######Parameters
Name       |    Type                  | Description
-----------|--------------------------|--------
fileName   | String                   | File name including full path
**Return** | Map&lt;String,String&gt; | Contains values for crc32, fileSize, fileName, and fileComment

######Example
```Apex
Zipper sampleZip = new Zipper();
sampleZip.addFileToZip('sampleFolder/test.txt', Blob.valueOf('Sample text.'), null);
Map <String, String> fileInfoMap = sampleZip.getFileInfo('sampleFolder/test.txt');
System.assertEquals ('12', fileInfoMap.get('fileSize'));
System.assertEquals ('sampleFolder/test.txt', fileInfoMap.get('fileName'));
```

####getZipFile()
```Apex
public Blob getZipFile()
```
Returns a Blob that contains the entire Zip archive.
######Parameters
Name       | Type       | Description
-----------|------------|--------
**Return** | Blob       | Full Zip archive data
######Example
```Apex
Zipper sampleZip = new Zipper();
sampleZip.addFileToZip('sampleFolder/test.txt', Blob.valueOf('Sample text.'), null);
Blob zipData = sampleZip.getZipFile();
```

####removeFileFromZip(fileName)
```Apex
public void removeFileFromZip(String fileName)
```
Removes a file from the current zip archive.
######Parameters
Name     | Type       | Description
---------|------------|--------
fileName | String     | File name to remove from zip archive including full path
######Example
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


####renameFile(oldName, newName)
```Apex
public void renameFile(String oldName, String newName)
```
Renames a file in the current zip archive.
######Parameters
Name     | Type       | Description
---------|------------|--------
oldName  | String     | The current file name to be modified
newName  | String     | The new name that replaces the current file name

######Example
```Apex
Zipper sampleZip = new Zipper();
sampleZip.addFileToZip('sampleFolder/file.txt', Blob.valueOf('Sample text1.'), null);
System.assert(sampleZip.getFileNames().contains('sampleFolder/file.txt'));
sampleZip.renameFile('sampleFolder/file.txt', 'sampleFolder/changedName.txt');
System.assert(sampleZip.getFileNames().contains('sampleFolder/file.txt') == false);
System.assert(sampleZip.getFileNames().contains('sampleFolder/changedName.txt'));
```


####removePrefix(prefix)
```Apex
public void removePrefix(String prefix)

```
Removes the specified prefix from all file names in the curent Zip archive only if it occurs at the beginning of the file name.
######Parameters
Name     | Type       | Description
---------|------------|--------
prefix   | String     | The prefix to remove from file names
######Example
```Apex
Zipper sampleZip = new Zipper();
sampleZip.addFileToZip('sampleFolder/file.txt', Blob.valueOf('Sample text1.'), null);
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
destObjId    | Id         | ID of the object to which unzipped files should be attached. If null the ParentId of the zip achive will be used
fileNames    | String[]   | List containing file names to uncompress.  If null, all files will be uncompressed
attemptAsync | Boolean    | If true, it attempts to unzip files in a future call
######Example
```Apex
Zipper.unzipAttachment('<ID_OF_ATTACHMENT>', null, null, false);
```


<!--###FAQ-->
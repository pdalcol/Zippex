public with sharing class Bits 
{
	private String bitBuffer;
	private Integer bitLocation;
	private Integer bitCursorLocation;
	
	
	// method that returns the next bit of a Hex Byte string.
	// uses class variables to keep track of the location and returns a boolean (0 = false, 1 = true)
	// Guessing we won't actually need this now.
	public Boolean getNextBit()
	{
		Integer stringCursorLocation = 0;
		Integer currentHighByte = 0;
		Integer currentLowByte = 0;
		Integer integerValueOfByte = 0;
		Integer subByteLocation = 0;
		
		
		stringCursorLocation = bitCursorLocation / 16;
		subByteLocation = math.mod(bitCursorLocation, 16);
		// need to check for length of string to see if we are at the end....
		currentHighByte = bitBuffer.charAt(stringCursorLocation);
		currentLowByte = bitBuffer.charAt(stringCursorLocation+1);
		//integerValueOfByte = HexUtil.hexToInt(currentByte,1);
		
		if (currentHighByte > 64)
			{
				integerValueOfByte = (currentHighByte - 55) * 16;
			}
			else
			{
				integerValueOfByte = (currentHighByte - 48) * 16;
			}
		If (currentLowByte > 64)
			{
				integerValueOfByte = integerValueOfByte + (currentLowByte - 55);
			}
			else
			{
				integerValueOfByte = integerValueOfByte + (currentLowByte - 48);
			}
		integerValueOfByte = integerValueofByte >> subByteLocation;
		if (math.mod(subByteLocation, 2) == 0)	
		{
			return False;
		}
		return True;
	}
		
		
	// requires a Hex string and returns an array of the integer values of the Hex bytes
	// For example:  "040A10FF" would return  an array [04, 10, 16, 255]
	// Uses charAt and the ASCI code to determine if the character is a number (48-57) or a letter (65 or higher)
	// Because each byte consists of two letters (high bits 11110000 the second low bits 00001111), the byte must be handled
	// in one iteration of the loop.
	// does not require other methods; it is completely autonomous.
	public static List<Integer> makeIntegerArray (String buffer)
	{
		Integer[] myValues = buffer.getChars();
		Integer size = myValues.size();
		
		Integer currentHighByte = 0;
		Integer currentLowByte = 0;
		Integer integerValueOfByte = 0;
		Integer[] returnIntegerArray = new List<Integer>();
		
		for (Integer stringCursorLocation = 0; stringCursorLocation < size;  stringCursorLocation = stringCursorLocation + 2)
		{
		//currentHighByte = bitBuffer.charAt(stringCursorLocation);
		//currentLowByte = bitBuffer.charAt(stringCursorLocation+1);
		currentHighByte = myValues[stringCursorLocation];
		currentLowByte = myValues[stringCursorLocation+1];
		
		integerValueOfByte = 0;
		if (currentHighByte > 64)  // value is a letter A-F, so the integer value should be 10-15).  This is the high value of the hex byte
			{
				integerValueOfByte = (currentHighByte - 55) * 16;  //subtract 55 to get a value of 10-15, and multiply by 16 since it is a bits 5-8.
			}
			else
			{
				integerValueOfByte = (currentHighByte - 48) * 16;  // value is a number 0-9, so subtract 48 and multiply by 16 since it is a bits 5-8.
			}
		if (currentLowByte > 64)  // this is the low value of the hex byte.  Repeat last logic; however, do not multiply by 16, instead add to last value.
			{
				integerValueOfByte = integerValueOfByte + (currentLowByte - 55);
			}
			else
			{
				integerValueOfByte = integerValueOfByte + (currentLowByte - 48);
			}
		returnIntegerArray.add(integerValueOfByte);  //add the computed integer value of the Hex byte to the integer array.
		}
		return returnIntegerArray;
	}
	
	
	//constructor - loads the bit buffer for keeping track of the bits and bytes
	public Bits (String buffer)
	{
		bitBuffer = buffer;
		bitLocation = 0;
		bitCursorLocation = 0;
		
	}
	
	public Integer getBitCursorLocation ()
	{
		return bitLocation;
	}
	
	public void setBitCursorLocation (Integer newLocation)
	{
		bitCursorLocation = newLocation;
	}
	
	
	// methods creates an array of boolean values representing the bits of an integer array of values
	// might be a long array, since each bit of the Hex Bytes is represented in order as a boolean value (False = 0, True = 1)
	public static List<Boolean> getBitArray (List<Integer> integerArray)
	{
		Boolean[] returnBitArray = new List<Boolean>();
		Integer counter = 0;
		Integer integerArraySize = integerArray.size();
		Boolean currentBitValue = false;
		Integer currentInteger = 0;
		for (counter = 0; counter < integerArraySize; counter++)
		{
			currentInteger = integerArray[counter];
			for (Integer innerloop = 0; innerloop < 8; innerloop++)
			{
				//currentBitValue =  math.mod(currentInteger,2) == 1;  //needs to be boolean, but should generate a value of 0 or 1
				currentBitValue =  (currentInteger & 128) == 128;  //needs to be boolean, but should generate a value of 0 or 1
				
				returnBitArray.add(currentBitValue);
				currentInteger = currentInteger << 1; // shift bits to the right so next byte will make the value odd or even for the mod function.
			}
		}
		return returnBitArray;
	}
	
	// method that takes a Hex Byte String, and returns an array of Booleans representing the bit values of the entire string's bytes
	// uses two methods in this class.
	public static List<Boolean>hexStringToBitArray (String hexByteString)
	{
		Integer[] integerArray = new List<Integer>();
		Boolean[] returnBitArray = new List<Boolean>();
		integerArray = makeIntegerArray(hexByteString);
		returnBitArray = getBitArray(integerArray);
		return returnBitArray;
	}
	
}
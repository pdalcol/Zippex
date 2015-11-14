/*************************************************************************
 *  Compilation:  javac CRC32.java
 *  Execution:    java CRC32 s
 *  
 *  Reads in a string s as a command-line argument, and prints out
 *  its 32 bit Cyclic Redundancy Check (CRC32 or Ethernet / AAL5 or ITU-TSS).
 *
 *  Uses direct table lookup, calculation, and Java library.
 *
 *  % java CRC32 123456789
 *  CRC32 (via table lookup)       = cbf43926
 *  CRC32 (via direct calculation) = cbf43926
 *  CRC32 (via Java's library)     = cbf43926
 *
 *
 *
 *  Uses irreducible polynomial:
 *     1    + x    + x^2  + x^4  + x^5  + x^7  + x^8  +
 *     x^10 + x^11 + x^12 + x^16 + x^22 + x^23 + x^26 
 *
 *  0000 0100 1100 0001 0001 1101 1011 0111                 
 *   0    4    C    1    1    D    B    7
 *
 *  The reverse of this polynomial is
 *
 *   0    2    3    8    8    B    D    E
 *
 *
 *
 *************************************************************************/


public class HexUtil { 

    public static Integer CRC32Table (Blob data) 
    { 

       /**************************************************************************
        *  Using table lookup
        *  Reference: http://snippets.dzone.com/tag/crc32
        **************************************************************************/
        Integer[] table = new List<Integer> { 
            0, 1996959894, -301047508, -1727442502, 124634137, 1886057615, -379345611, -1637575261,
            249268274, 2044508324, -522852066, -1747789432, 162941995, 2125561021, -407360249, -1866523247, 
            498536548, 1789927666, -205950648, -2067906082, 450548861, 1843258603, -187386543, -2083289657, 
            325883990, 1684777152, -43845254, -1973040660, 335633487, 1661365465, -99664541, -1928851979, 
            997073096, 1281953886, -715111964, -1570279054, 1006888145, 1258607687, -770865667, -1526024853, 
            901097722, 1119000684, -608450090, -1396901568, 853044451, 1172266101, -589951537, -1412350631, 
            651767980, 1373503546, -925412992, -1076862698, 565507253, 1454621731, -809855591, -1195530993, 
            671266974, 1594198024, -972236366, -1324619484, 795835527, 1483230225, -1050600021, -1234817731, 
            1994146192, 31158534, -1731059524, -271249366, 1907459465, 112637215, -1614814043, -390540237, 
            2013776290, 251722036, -1777751922, -519137256, 2137656763, 141376813, -1855689577, -429695999, 
            1802195444, 476864866, -2056965928, -228458418, 1812370925, 453092731, -2113342271, -183516073, 
            1706088902, 314042704, -1950435094, -54949764, 1658658271, 366619977, -1932296973, -69972891, 
            1303535960, 984961486, -1547960204, -725929758, 1256170817, 1037604311, -1529756563, -740887301, 
            1131014506, 879679996, -1385723834, -631195440, 1141124467, 855842277, -1442165665, -586318647, 
            1342533948, 654459306, -1106571248, -921952122, 1466479909, 544179635, -1184443383, -832445281, 
            1591671054, 702138776, -1328506846, -942167884, 1504918807, 783551873, -1212326853, -1061524307, 
            -306674912, -1698712650, 62317068, 1957810842, -355121351, -1647151185, 81470997, 1943803523, 
            -480048366, -1805370492, 225274430, 2053790376, -468791541, -1828061283, 167816743, 2097651377, 
            -267414716, -2029476910, 503444072, 1762050814, -144550051, -2140837941, 426522225, 1852507879, 
            -19653770, -1982649376, 282753626, 1742555852, -105259153, -1900089351, 397917763, 1622183637, 
            -690576408, -1580100738, 953729732, 1340076626, -776247311, -1497606297, 1068828381, 1219638859, 
            -670225446, -1358292148, 906185462, 1090812512, -547295293, -1469587627, 829329135, 1181335161, 
            -882789492, -1134132454, 628085408, 1382605366, -871598187, -1156888829, 570562233, 1426400815, 
            -977650754, -1296233688, 733239954, 1555261956, -1026031705, -1244606671, 752459403, 1541320221, 
            -1687895376, -328994266, 1969922972, 40735498, -1677130071, -351390145, 1913087877, 83908371, 
            -1782625662, -491226604, 2075208622, 213261112, -1831694693, -438977011, 2094854071, 198958881, 
            -2032938284, -237706686, 1759359992, 534414190, -2118248755, -155638181, 1873836001, 414664567, 
            -2012718362, -15766928, 1711684554, 285281116, -1889165569, -127750551, 1634467795, 376229701, 
            -1609899400, -686959890, 1308918612, 956543938, -1486412191, -799009033, 1231636301, 1047427035, 
            -1362007478, -640263460, 1088359270, 936918000, -1447252397, -558129467, 1202900863, 817233897, 
            -1111625188, -893730166, 1404277552, 615818150, -1160759803, -841546093, 1423857449, 601450431, 
            -1285129682, -1000256840, 1567103746, 711928724, -1274298825, -1022587231, 1510334235, 755167117};
Map<String,Integer> hexMap = new Map<String,Integer>
        {
        '0'=>0,'1'=>1,'2'=>2,'3'=>3,'4'=>4,'5'=>5,'6'=>6,'7'=>7,'8'=>8,'9'=>9,'a'=>10,
        'b'=>11,'c'=>12,'d'=>13,'e'=>14,'f'=>15,'A'=>10,'B'=>11,'C'=>12,'D'=>13,'E'=>14,'F'=>15
        };
/*        String[] table = new List<String> {
            '00000000', '77073096', 'ee0e612c', '990951ba', '076dc419', '706af48f', 'e963a535', '9e6495a3',
            '0edb8832', '79dcb8a4', 'e0d5e91e', '97d2d988', '09b64c2b', '7eb17cbd', 'e7b82d07', '90bf1d91',
            '1db71064', '6ab020f2', 'f3b97148', '84be41de', '1adad47d', '6ddde4eb', 'f4d4b551', '83d385c7',
            '136c9856', '646ba8c0', 'fd62f97a', '8a65c9ec', '14015c4f', '63066cd9', 'fa0f3d63', '8d080df5',
            '3b6e20c8', '4c69105e', 'd56041e4', 'a2677172', '3c03e4d1', '4b04d447', 'd20d85fd', 'a50ab56b',
            '35b5a8fa', '42b2986c', 'dbbbc9d6', 'acbcf940', '32d86ce3', '45df5c75', 'dcd60dcf', 'abd13d59',
            '26d930ac', '51de003a', 'c8d75180', 'bfd06116', '21b4f4b5', '56b3c423', 'cfba9599', 'b8bda50f',
            '2802b89e', '5f058808', 'c60cd9b2', 'b10be924', '2f6f7c87', '58684c11', 'c1611dab', 'b6662d3d',
            '76dc4190', '01db7106', '98d220bc', 'efd5102a', '71b18589', '06b6b51f', '9fbfe4a5', 'e8b8d433',
            '7807c9a2', '0f00f934', '9609a88e', 'e10e9818', '7f6a0dbb', '086d3d2d', '91646c97', 'e6635c01',
            '6b6b51f4', '1c6c6162', '856530d8', 'f262004e', '6c0695ed', '1b01a57b', '8208f4c1', 'f50fc457',
            '65b0d9c6', '12b7e950', '8bbeb8ea', 'fcb9887c', '62dd1ddf', '15da2d49', '8cd37cf3', 'fbd44c65',
            '4db26158', '3ab551ce', 'a3bc0074', 'd4bb30e2', '4adfa541', '3dd895d7', 'a4d1c46d', 'd3d6f4fb',
            '4369e96a', '346ed9fc', 'ad678846', 'da60b8d0', '44042d73', '33031de5', 'aa0a4c5f', 'dd0d7cc9',
            '5005713c', '270241aa', 'be0b1010', 'c90c2086', '5768b525', '206f85b3', 'b966d409', 'ce61e49f',
            '5edef90e', '29d9c998', 'b0d09822', 'c7d7a8b4', '59b33d17', '2eb40d81', 'b7bd5c3b', 'c0ba6cad',
            'edb88320', '9abfb3b6', '03b6e20c', '74b1d29a', 'ead54739', '9dd277af', '04db2615', '73dc1683',
            'e3630b12', '94643b84', '0d6d6a3e', '7a6a5aa8', 'e40ecf0b', '9309ff9d', '0a00ae27', '7d079eb1',
            'f00f9344', '8708a3d2', '1e01f268', '6906c2fe', 'f762575d', '806567cb', '196c3671', '6e6b06e7',
            'fed41b76', '89d32be0', '10da7a5a', '67dd4acc', 'f9b9df6f', '8ebeeff9', '17b7be43', '60b08ed5',
            'd6d6a3e8', 'a1d1937e', '38d8c2c4', '4fdff252', 'd1bb67f1', 'a6bc5767', '3fb506dd', '48b2364b',
            'd80d2bda', 'af0a1b4c', '36034af6', '41047a60', 'df60efc3', 'a867df55', '316e8eef', '4669be79',
            'cb61b38c', 'bc66831a', '256fd2a0', '5268e236', 'cc0c7795', 'bb0b4703', '220216b9', '5505262f',
            'c5ba3bbe', 'b2bd0b28', '2bb45a92', '5cb36a04', 'c2d7ffa7', 'b5d0cf31', '2cd99e8b', '5bdeae1d',
            '9b64c2b0', 'ec63f226', '756aa39c', '026d930a', '9c0906a9', 'eb0e363f', '72076785', '05005713',
            '95bf4a82', 'e2b87a14', '7bb12bae', '0cb61b38', '92d28e9b', 'e5d5be0d', '7cdcefb7', '0bdbdf21',
            '86d3d2d4', 'f1d4e242', '68ddb3f8', '1fda836e', '81be16cd', 'f6b9265b', '6fb077e1', '18b74777',
            '88085ae6', 'ff0f6a70', '66063bca', '11010b5c', '8f659eff', 'f862ae69', '616bffd3', '166ccf45',
            'a00ae278', 'd70dd2ee', '4e048354', '3903b3c2', 'a7672661', 'd06016f7', '4969474d', '3e6e77db',
            'aed16a4a', 'd9d65adc', '40df0b66', '37d83bf0', 'a9bcae53', 'debb9ec5', '47b2cf7f', '30b5ffe9',
            'bdbdf21c', 'cabac28a', '53b39330', '24b4a3a6', 'bad03605', 'cdd70693', '54de5729', '23d967bf',
            'b3667a2e', 'c4614ab8', '5d681b02', '2a6f2b94', 'b40bbe37', 'c30c8ea1', '5a05df1b', '2d02ef8d'
        };
*/


        String hexString = EncodingUtil.convertToHex(data);
        Integer b = 0;
        Integer crc =  hexToInt('ffffffff');
        for (Integer i = 0; i < hexString.length()/2; i++)
        {
            //b = hexToInt(hexString.substring(i*2, i*2+2));
            //crc = (crc >>> 8) ^ hexToInt(table[(crc ^ b) & 255]);

            b = hexMap.get(hexString.substring(i*2, i*2+1)) * 16 
                + hexMap.get(hexString.substring(i*2+1, i*2+2));

            crc = (crc >>> 8) ^ table[(crc ^ b) & 255];
        }

        // flip bits
        crc = crc ^  hexToInt('ffffffff');

        System.debug('CRC32 (via table lookup)       = ' + intToHex(crc,4));
        return crc;
}


       /**************************************************************************
        *  Using direct calculation
        **************************************************************************/
   public static Integer CRC32Calc (Blob data) 
{
        Integer crc =  hexToInt('ffffffff');
        String hexString = EncodingUtil.convertToHex(data);
        crc  = hexToInt('FFFFFFFF');       // initial contents of LFBSR
        Integer poly = hexToInt('EDB88320');   // reverse polynomial
        Integer b = 0;

         for (Integer j = 0; j < hexString.length()/2; j++)
         {
           b = hexToInt(hexString.substring(j*2, j*2+2));
           Integer temp = (crc ^ b) & hexToInt('ff');

            // read 8 bits one at a time
            for (Integer i = 0; i < 8; i++) 
            {
                if ((temp & 1) == 1) temp = (temp >>> 1) ^ poly;
                else                
                     temp = (temp >>> 1);
            }
           crc = (crc >>> 8) ^ temp;
          }

        // flip bits
       crc = crc ^ hexToInt('ffffffff');

      System.debug('CRC32 (via direct calculation) = ' + intToHex(crc,4));
        
        return crc;


    }



    public static Integer hexToInt (String hexString)
    {
        Map<String,Integer> hexMap = new Map<String,Integer>
        {
        '0'=>0,'1'=>1,'2'=>2,'3'=>3,'4'=>4,'5'=>5,'6'=>6,'7'=>7,'8'=>8,'9'=>9,'a'=>10,
        'b'=>11,'c'=>12,'d'=>13,'e'=>14,'f'=>15,'A'=>10,'B'=>11,'C'=>12,'D'=>13,'E'=>14,'F'=>15
        };
        
        Integer tempInteger = 0;
        Integer returnedInteger = 0;
        for (Integer j = 0; j < hexString.length(); j++)
        {
            tempInteger = hexMap.get(hexString.substring(hexString.length()-(j+1), hexString.length()-j));
            returnedInteger += tempInteger * (Integer)Math.pow(16,j);
        
        }
            
        return returnedInteger;  //signed Integer, could return negative
    }

    public static Long hexToIntLittleEndian (String hexString)
    {  
    	Long mask = 4294967295L; //FFFFFF
        String tempString = '';
        
        for (Integer j = hexString.length(); j > 0; j=j-2)
        
        	{
        		tempString = tempString + hexString.substring(j-2,j-1);
        		tempString = tempString + hexString.substring(j-1,j);
        	}
		return hexToInt(tempString) & mask;       
    }



public static String intToHex (Integer decNumber, Integer sizeInBytes)
{
Long mask = 4294967295L; //FFFFFF
Long decimalNumber = decNumber & mask;
String LEHexStringOfDecimal = '';
Long remainder = 0;
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


}
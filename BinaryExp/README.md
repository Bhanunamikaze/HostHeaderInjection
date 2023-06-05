# ConvertHexDecReverse
- This code converts 
  - Decimal to Hex 
  - Hex to Decimal 
  - Hex to Reverse hex (Negation) ( Ex: 0xffffffc0,  # After nagation, becomes 0x40; 0x10014db4,   # NEG EAX # RETN ) 

## Usage 
ConvertHexDecReverse.py [-h] (--hex HEX | --dec DEC)

*Example*
python ConvertHexDecReverse.py --hex 0x40
Hex 0x40 to decimal: 64
Hex 0x40 to reversed hex: 0xFFFFFFC0

python ConvertHexDecReverse.py --dec 60  
Decimal 60 to hex: 0x0000003C


# MemoryAddressToHex.sh 
- This code converts 
  - Hex Addresses from Binaries to Normal Hex values 
  - Converts Hex values into Little Endian Format

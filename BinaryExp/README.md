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


Usage: ./ConvertHexDecReverse.sh [OPTIONS]
Convert hexadecimal and decimal values

Options:
  --hex HEX_VALUE    Convert hexadecimal value to decimal and reversed hex
  --dec DEC_VALUE    Convert decimal value to hex

# MemoryAddressToHex.sh 

This repository contains a Bash script that enables the conversion of memory addresses from little endian format to hexadecimal representation. The script is designed to be simple and easy to use, making it a handy tool for developers, security researchers, and anyone working with low-level programming.

## Features:
  Converts memory addresses to little endian format
  Generates the corresponding hexadecimal value
  
## Usage:
$ bash MemoryAddressToHex.sh 08048490

[*] Given Input is: 08048490
[*] Little Endian Output is: 90480408
[*] Hex Value of the Memory Address is: \x90\x48\x04\x08

  

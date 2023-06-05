#!/bin/bash

if [ $# -eq 0 ]
        then
                echo "[+] This Script is used to Convert Memory Address to Little endian and then to HEX; Do not add 0x at the start of the address"
		echo "[+] Usage: $0 Memory_Address"
                echo "[+] Example: $0 08048490"
                echo "[+] for ease of access, create a symbolic link or copy the file into /usr/local/bin/convert.sh"
                exit
        else
		echo ""
                echo "[*] Given Input is : $1"
fi

v=`echo $1`
i=${#v}

while [ $i -gt 0 ]
do
    i=$[$i-2]
    lit_end+=$(echo -n ${v:$i:2})
done

echo "[*] Little Endian Output is:  $lit_end"
hex=$(echo $lit_end|   awk -v FS='' '{for(i=1;i<NF;i+=2) printf "\\x%s%s",$i,$(i+1)}END{printf ""}')
echo "[*] Hex Value of the Memory Address is: $hex"
echo ""

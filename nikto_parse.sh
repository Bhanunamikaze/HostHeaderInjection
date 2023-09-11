#!/bin/bash
# Author: BhanuNamikaze
# A Tool to parse multiple nikto outputs at once to find/list missing headers, then group it together based on IP,Port and missing headers
# Runs the script on Present working directory, looks for filename nikto_ip_port.txt recursively and shows the output in csv format. 
# Example output: 127.0.0.1, "80, 443", "X-Frame-Options" "X-XSS-Protection" "X-Content-Type-Options""
# Usage: 
# wget 
# chmod +x nikto_parse.sh
# ./nikto_parse.sh

current_dir=$(pwd)

# List of headers to parse
headers=("X-Frame-Options" "X-XSS-Protection" "X-Content-Type-Options" "Strict-Transport-Security")

declare -A missing_headers_map

while IFS= read -r -d '' filename; do
    ip_port=$(basename "$filename" | sed -n 's/^nikto_\([0-9\.]*_[0-9]*\)\.txt$/\1/p')
    ip="${ip_port%_*}"
    port="${ip_port#*_}"
    missing_headers=""
    
    for header in "${headers[@]}"; do
        if grep -q "$header" "$filename"; then
            missing_headers="$missing_headers, $header"
        fi
    done
    
    missing_headers=${missing_headers#, } 
    if [ -n "$missing_headers" ]; then
        # Store the missing headers for the IP and port combination in the  array
        if [ -n "${missing_headers_map["$ip,$missing_headers"]}" ]; then
            missing_headers_map["$ip,$missing_headers"]+=", $port"
        else
            missing_headers_map["$ip,$missing_headers"]=$port
        fi
    fi
done < <(find "$current_dir" -type f -name 'nikto_*.txt' -print0)

echo "ip, port, missing_headers"

#Group results to show in csv format
for key in "${!missing_headers_map[@]}"; do
    IFS="," read -r ip missing_headers <<< "$key"
    ports="${missing_headers_map["$key"]}"
    echo "$ip, \"$ports\", \"$missing_headers\""
done

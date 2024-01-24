#!/bin/bash
# This script takes an input file with a list of IP addresses or hosts
# and runs curl commands on both port 80 and 443 to fetch the response status code.

# Check if the input file exists
if [ ! -f "$1" ]; then
  echo "Usage: $0 <host_list_file>"
  exit 1
fi

# Loop through each host in the file
while IFS= read -r host; do
  if [ -n "$host" ] && ! [[ "$host" =~ ^# ]]; then
    # Check port 80
    response_code_80=$(curl --connect-timeout 3 -s -kL -o /dev/null -w "%{http_code}" "http://$host/")
    echo "$host, 80, $response_code_80 "

    # Check port 443
    response_code_443=$(curl --connect-timeout 3 -s -kL -o /dev/null -w "%{http_code}" "https://$host/")
    echo "$host, 443,  $response_code_443 "
  fi
done < "$1"

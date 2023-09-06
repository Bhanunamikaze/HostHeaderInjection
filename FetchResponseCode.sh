#!/bin/bash
# This script takes input file with list of ip addresses or hosts and runs curl command on all the hosts to fetch its response status code.

# Check if the input file exists
if [ ! -f "$1" ]; then
  echo "Usage: $0 <host_list_file>"
  exit 1
fi

# Loop through each host in the file
while IFS= read -r host; do
  if [ -n "$host" ] && ! [[ "$host" =~ ^# ]]; then
    echo -n "Host: $host, Response Code: "

    response_code=$(curl --connect-timeout 3 -s -kL  -o /dev/null -w "%{http_code}" "https://$host/")

    echo "$host, $response_code"
  fi
done < "$1"

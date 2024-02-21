#!/bin/bash
#Wordpress Scanner - This script takes a file--'list of domains or ip_addresses' as input and check if the host is running wordpress on it 
#If a Wordpress Installation is identified, wpscan is run on the found host. 

if [ $# -eq 0 ]; then
    echo "Usage: $0 <ip_file>"
    exit 1
fi

wp_dir="wordpress"
if [ ! -d "$wp_dir" ]; then
    mkdir "$wp_dir"
fi

while IFS= read -r ip
do
    url=$(curl -kLs "${ip}" | grep wp-content | sed -n "s/.*\(https\{0,1\}:\/\/\([^\/'\"]*\)\).*/\2/p" | grep -v cdn | sort | uniq -c | sort -rn | awk 'NR==1 {print $2}')

    if [ -n "$url" ]; then
        echo "Running Wordpress Scan on Domain: $url"
        wpscan --url "$url" --api-token <your WP Token Here> -o "wordpress/wordpress_${ip}.txt"
    else
        echo "No WordPress URLs found for $ip."
    fi
done < "$1"


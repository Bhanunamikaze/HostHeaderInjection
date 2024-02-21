if [ $# -eq 0 ]; then
    echo "Usage: $0 <url_file>"
    exit 1
fi

search_string="Error 404 Not Found"

while IFS= read -r url
do
    curl_output=$(curl -skL "$url")

    if [[ "$curl_output" =~ $search_string ]]; then
        echo "$url, 404"
    else
        echo "$url, Accessible"
    fi
done < "$1"

#!/bin/bash
#This can be used to create simple wordlist based detection 

if [ $# -eq 0 ]
        then
                echo "Usage: $0 <IP> Nmap_Ports.txt"
                echo "Example: $0 10.10.10.10 ports.txt"
                echo "for ease of access, create a symbolic link or copy the file into /usr/local/bin/webtest.sh"
                exit
        else
				echo "[*] Starting the Test [*]"
fi

#Collect the port numbers from nmap output
input_file=$(cat $2| grep open | grep -v Nmap | cut -d '/' -f1 > /tmp/adssadsa.txt)
	
for port in $(cat /tmp/adssadsa.txt); do
	http_code=$(curl https://$1:$port -kL -w '%{http_code}' -o /dev/null -s )
		if [[ $http_code -eq 200 ]] || [[ $http_code -eq 301 ]]; then 
			echo "[^] Something is accessible at HTTPS://$1:$port and Status Code is: $http_code"
		fi
	http_code=$(curl https://$1:$port -kL -w '%{http_code}' -o /dev/null -s )
		if [[ $http_code -eq 200 ]] || [[ $http_code -eq 301 ]];  then 
			echo "[^] Something is accessible at HTTP://$1:$port and Status Code is: $http_code"
		fi
	http_code=$(curl http://$1:$port/version -kL -w '%{http_code}' -o /dev/null -s )
		if [[ $http_code -eq 200 ]] || [[ $http_code -eq 403 ]]; then 
			echo "[+] K8 Version accessible at https://$1:$port/version and Status Code is: $http_code"
		fi
	http_code=$(curl http://$1:$port/debug/pprof/ -L -w '%{http_code}' -o /dev/null -s )
		if [[ $http_code -eq 200 ]]; then 
			echo "[+] go pprof Debug is accessible at https://$1:$port/debug/pprof/ and Status Code is: $http_code"
		fi
	http_code=$(curl http://$1:$port/metrics -kL -w '%{http_code}' -o /dev/null -s )
		if [[ $http_code -eq 200 ]]; then 
			echo "[+] Metrics is accessible at https://$1:$port/metrics and Status Code is: $http_code".
		fi
	http_code=$(curl https://$1:$port/.well-known/openid-configuration -kL -w '%{http_code}' -o /dev/null -s )
		if [[ $http_code -eq 200 ]]; then 
			echo "[+] openid Config is accessible at https://$1:$port/.well-known/openid-configuration and Status Code is: $http_code"
		fi

done
rm /tmp/adssadsa.txt
echo "[*] Ending the Test [*]"

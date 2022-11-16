/*
Author: Bhanu Namikaze
Description: Testing for Host header injection Vulnerabilities 
Todo: Auth Bypas using HHI, add more exploitation techniques
*/

package main
import (
   "bytes"
   "fmt"
   "io"
   "log"
   "math/rand"
   "net/http"
   "net/url"
   "strconv"
   "strings"
   "time"
  ) 

var obj = &data{}
var port = 78545

type data struct {
    randdomain string
    PayloadHeader http.Header
}

func CheckResponse(PayloadHeader http.Header, method string, InitUrl *url.URL) bool {
    Vulnerable := false
    Url := InitUrl.String()
    for i := 0; i < 2; i ++ {
        req,err := http.NewRequest(method, Url, nil)
        if err != nil {
			log.Fatalf("Error occurred. %+v", err)
        }

        req.Header = PayloadHeader
        // fmt.Println (req.Header)

        client := &http.Client{Timeout: 10 * time.Second}
        resp, err := client.Do(req)
        if err != nil {
            log.Fatalf("Error Occurred. %+v", err)
        }

        body, err := io.ReadAll(resp.Body)
        ResBody := bytes.NewBuffer(body).String()
        if err != nil {
			log.Fatalf("Couldn't parse response body. %+v", err)
        }

        ResHeaders := fmt.Sprint (resp.Header)
         // fmt.Println ("ResHeaders", ResHeaders)
         // fmt.Println ("ResBody", ResBody)
        // fmt.Println ("StatusCode is :", resp. StatusCode)

		// +1 the port number if the value already exists in the response
		if strings.Contains(ResBody,strconv.Itoa(port)) {
			port = port + 1
		}

		if strings.Contains(ResBody, obj.randdomain) || strings.Contains(ResBody, strconv.Itoa(port)) ||strings.Contains(ResHeaders, obj.randdomain) || strings.Contains(ResHeaders, strconv.Itoa(port)){
			// Application is Vulnerable
			fmt.Println("New Host Header Domain Found in Resonse", obj.randdomain)
			Vulnerable = true
		}else {
			//fmt.Println("Given Domain is not Vulnerable to Host Header Injection")
			Vulnerable = false
		}
	}

	return Vulnerable
}

func randSeq(n int) string {
    var letters = []rune("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
    b := make ([]rune, n)
	for i := range b {
        b[i] = letters[rand.Intn(len(letters))]
   }
    return string(b)
}

// x-forwarded-port 
func XForwardPort(Url *url.URL, ports string) http.Header {
	u := Url.String()
	url_host, _ := url.Parse(u)
	PayloadHeader := http.Header{
		"Host": {url_host.Host},
		"User-Agent": {"Testing Shit"},
		"Content-Type": {"application/x-www-form-urlencoded"},
		"X-Forwarded-Port": {ports},
		"Accept-Language": {"en-US,en;q=0.5"},
	}
	return PayloadHeader

}

//X-Forwarded-Host with/without port 
func XForwardHost(Url *url.URL, element string, ports string) http.Header {
	obj.randdomain = randSeq(8) + ".com"
	u := Url.String()
	url_host, _ := url.Parse(u)
	PayloadHeader := http.Header{
		"Host": {url_host.Host},
		"User-Agent": {"Testing Shit"},
		"Content-Type": {"application/x-www-form-urlencoded"},
		element: {obj.randdomain + ports},
		"Accept-Language": {"en-US,en;q=0.5"},
	}
	return PayloadHeader

}


// Function to start
func scan (Url *url.URL) int {
    port := strconv.Itoa(port)
    x_header := []string{"X-Forwarded-Host","X-Host","Host","X-Client-IP","X-Remote-IP","X-Remote-Addr","Host"}    
    x_port := []string{"",":"+ port,":@"+port, " " + port}

    // Requests are sent twice for Cache Validation ; 2nd Request Should show Cache-Hit
    for i := 0 ; i < 2 ; i ++ {
        for _, element := range x_header {
			for _, ports := range x_port {
				req := XForwardHost (Url, element, ports)
				final := CheckResponse (req,"GET", Url)
				if final {
					return 1
				}
			}
      	}

        for _, ports := range x_port {
            req := XForwardPort(Url, ports)
            final := CheckResponse(req,"GET", Url)
           if final {
               return 1
		   }
       }

		for _, ports := range x_port {
			req := XForwardPort (Url,ports)
			final := CheckResponse(req,"GET", Url)
		    if final {
				return 1
			}
		}
	}
	return 0
}

func main() {

   start,err := url.Parse ("https://vuln.domain.com")
   if err != nil {
       fmt.Println(err)
   }
   output := scan(start)
   if output == 1 {
	fmt.Println("Application is VULNERABLE to Host Header Injection Attacks")
   } else {
       fmt.Println("Application is not Vulnerable to Host Header Injection Attacks")
   }
   
}

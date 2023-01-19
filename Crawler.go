//Simple Web Page Crawler 

package main

import (
	"fmt"
	"net/http"

	"golang.org/x/net/html"
)

var visited = make(map[string]bool)

func main() {
	urls := []string{"https://www.google.com/"}
	for len(urls) > 0 {
		url := urls[0]
		urls = urls[1:]
		if visited[url] {
			continue
		}
		visited[url] = true
		links, err := getLinks(url)
		if err != nil {
			fmt.Println(err)
			continue
		}
		urls = append(urls, links...)
	}
}

func getLinks(url string) ([]string, error) {
	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("getting %s: %s", url, resp.Status)
	}

	doc, err := html.Parse(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("parsing %s as HTML: %v", url, err)
	}

	var links []string
	visitNode := func(n *html.Node) {
		if n.Type == html.ElementNode && n.Data == "a" {
			for _, a := range n.Attr {
				if a.Key != "href" {
					continue
				}
				link, err := resp.Request.URL.Parse(a.Val)
				if err != nil {
					continue // ignore bad URLs
				}
				links = append(links, link.String())
			}
		}
	}
	forEachNode(doc, visitNode, nil)
	return links, nil
}

func forEachNode(n *html.Node, pre, post func(n *html.Node)) {
	if pre != nil {
		pre(n)
	}
	for c := n.FirstChild; c != nil; c = c.NextSibling {
		forEachNode(c, pre, post)
	}
	if post != nil {
		post(n)
	}
}

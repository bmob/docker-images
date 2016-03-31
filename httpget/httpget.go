package main

import (
	"fmt"
	"net"
	"net/http"
	"os"
)

func main() {
	if len(os.Args) < 2 {
		return
	}

	APPID := os.Getenv("APPID")
	BANDWIDTH := os.Getenv("BANDWIDTH")

	addrs, err := net.InterfaceAddrs()
	if err != nil {
		req := fmt.Sprintf("%s?ip=null&appid=%s&bandwidth=%s", os.Args[1], APPID, BANDWIDTH)
		http.Get(req)
		os.Exit(1)
	}

	var ip string
	ip = ""
	for _, address := range addrs {
		if ipnet, ok := address.(*net.IPNet); ok && !ipnet.IP.IsLoopback() {
			if ipnet.IP.To4() != nil {
				ip = ipnet.IP.String()
			}

		}
	}

	req := fmt.Sprintf("%s?ip=%s&appid=%s&bandwidth=%s", os.Args[1], ip, APPID, BANDWIDTH)
	fmt.Println("net limit url=" + req)
	http.Get(req)
}

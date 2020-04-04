package main

import (
	"Demo/GoHttp/client"
	"net/http"

	"github.com/TarsCloud/TarsGo/tars"
)

func main() { //Init servant
	mux := &tars.TarsHttpMux{}
	mux.HandleFunc("/test/ping", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("pong"))
	})

	mux.HandleFunc("/test/pingGo", func(w http.ResponseWriter, r *http.Request) {
		ret, err := client.PingGo()
		if err != nil {
			w.Write([]byte("Exception raised on ping go tars"))
		} else {
			w.Write([]byte(ret))
		}
	})
	servCfg := tars.GetServerConfig()
	tars.AddHttpServant(mux, servCfg.App+"."+servCfg.Server+".HelloObj") //Register http server
	tars.Run()
}

package main

import (
	"github.com/TarsCloud/TarsGo/tars"

	"Demo/GoTars/Demo"
)

func main() { //Init servant
	imp := new(HelloImpl)                                   //New Imp
	app := new(Demo.Hello)                                  //New init the A Tars
	cfg := tars.GetServerConfig()                           //Get Config File Object
	app.AddServant(imp, cfg.App+"."+cfg.Server+".HelloObj") //Register Servant
	tars.Run()
}

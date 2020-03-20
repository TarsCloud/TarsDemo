package client

import (
	"Demo/GoHttp/Demo"

	"github.com/TarsCloud/TarsGo/tars"
)

var comm *tars.Communicator

func PingGo() (string, error) {
	comm = tars.NewCommunicator()
	obj := "Demo.GoTars.HelloObj"
	app := new(Demo.Hello)
	clientCfg := tars.GetClientConfig()
	comm.SetProperty("locator", clientCfg.Locator)
	comm.StringToProxy(obj, app)
	ret, err := app.Ping()

	return ret, err
}

package main

type HelloImpl struct {
}

func (imp *HelloImpl) Ping() (string, error) {
	//Doing something in your function
	//...
	return "pong", nil
}

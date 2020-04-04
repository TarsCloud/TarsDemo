//Package Demo comment
// This file war generated by tars2go 1.1
// Generated from go.tars
package Demo

import (
	"context"
	"fmt"
	"github.com/TarsCloud/TarsGo/tars"
	m "github.com/TarsCloud/TarsGo/tars/model"
	"github.com/TarsCloud/TarsGo/tars/protocol/codec"
	"github.com/TarsCloud/TarsGo/tars/protocol/res/requestf"
	"github.com/TarsCloud/TarsGo/tars/util/current"
	"github.com/TarsCloud/TarsGo/tars/util/tools"
)

//Hello struct
type Hello struct {
	s m.Servant
}

//Ping is the proxy function for the method defined in the tars file, with the context
func (_obj *Hello) Ping(_opt ...map[string]string) (ret string, err error) {

	var length int32
	var have bool
	var ty byte
	_os := codec.NewBuffer()

	var _status map[string]string
	var _context map[string]string
	if len(_opt) == 1 {
		_context = _opt[0]
	} else if len(_opt) == 2 {
		_context = _opt[0]
		_status = _opt[1]
	}
	_resp := new(requestf.ResponsePacket)
	ctx := context.Background()
	err = _obj.s.Tars_invoke(ctx, 0, "Ping", _os.ToBytes(), _status, _context, _resp)
	if err != nil {
		return ret, err
	}
	_is := codec.NewReader(tools.Int8ToByte(_resp.SBuffer))
	err = _is.Read_string(&ret, 0, true)
	if err != nil {
		return ret, err
	}

	_obj.setMap(len(_opt), _resp, _context, _status)
	_ = length
	_ = have
	_ = ty
	return ret, nil
}

//PingWithContext is the proxy function for the method defined in the tars file, with the context
func (_obj *Hello) PingWithContext(ctx context.Context, _opt ...map[string]string) (ret string, err error) {

	var length int32
	var have bool
	var ty byte
	_os := codec.NewBuffer()
	var _status map[string]string
	var _context map[string]string
	if len(_opt) == 1 {
		_context = _opt[0]
	} else if len(_opt) == 2 {
		_context = _opt[0]
		_status = _opt[1]
	}
	_resp := new(requestf.ResponsePacket)
	err = _obj.s.Tars_invoke(ctx, 0, "Ping", _os.ToBytes(), _status, _context, _resp)
	if err != nil {
		return ret, err
	}
	_is := codec.NewReader(tools.Int8ToByte(_resp.SBuffer))
	err = _is.Read_string(&ret, 0, true)
	if err != nil {
		return ret, err
	}

	_obj.setMap(len(_opt), _resp, _context, _status)
	_ = length
	_ = have
	_ = ty
	return ret, nil
}

//SetServant sets servant for the service.
func (_obj *Hello) SetServant(s m.Servant) {
	_obj.s = s
}

//TarsSetTimeout sets the timeout for the servant which is in ms.
func (_obj *Hello) TarsSetTimeout(t int) {
	_obj.s.TarsSetTimeout(t)
}
func (_obj *Hello) setMap(l int, res *requestf.ResponsePacket, ctx map[string]string, sts map[string]string) {
	if l == 1 {
		for k, _ := range ctx {
			delete(ctx, k)
		}
		for k, v := range res.Context {
			ctx[k] = v
		}
	} else if l == 2 {
		for k, _ := range ctx {
			delete(ctx, k)
		}
		for k, v := range res.Context {
			ctx[k] = v
		}
		for k, _ := range sts {
			delete(sts, k)
		}
		for k, v := range res.Status {
			sts[k] = v
		}
	}
}

//AddServant adds servant  for the service.
func (_obj *Hello) AddServant(imp _impHello, obj string) {
	tars.AddServant(_obj, imp, obj)
}

//AddServant adds servant  for the service with context.
func (_obj *Hello) AddServantWithContext(imp _impHelloWithContext, obj string) {
	tars.AddServantWithContext(_obj, imp, obj)
}

type _impHello interface {
	Ping() (ret string, err error)
}
type _impHelloWithContext interface {
	Ping(ctx context.Context) (ret string, err error)
}

func Ping(ctx context.Context, _val interface{}, _os *codec.Buffer, _is *codec.Reader, withContext bool) (err error) {
	var length int32
	var have bool
	var ty byte
	if withContext == false {
		_imp := _val.(_impHello)
		ret, err := _imp.Ping()
		if err != nil {
			return err
		}

		err = _os.Write_string(ret, 0)
		if err != nil {
			return err
		}
	} else {
		_imp := _val.(_impHelloWithContext)
		ret, err := _imp.Ping(ctx)
		if err != nil {
			return err
		}

		err = _os.Write_string(ret, 0)
		if err != nil {
			return err
		}
	}

	_ = length
	_ = have
	_ = ty
	return nil
}

//Dispatch is used to call the server side implemnet for the method defined in the tars file. withContext shows using context or not.
func (_obj *Hello) Dispatch(ctx context.Context, _val interface{}, req *requestf.RequestPacket, resp *requestf.ResponsePacket, withContext bool) (err error) {
	_is := codec.NewReader(nil)
	_os := codec.NewBuffer()
	switch req.SFuncName {
	case "Ping":
		err := Ping(ctx, _val, _os, _is, withContext)
		if err != nil {
			return err
		}

	default:
		return fmt.Errorf("func mismatch")
	}
	var _status map[string]string
	s, ok := current.GetResponseStatus(ctx)
	if ok && s != nil {
		_status = s
	}
	var _context map[string]string
	c, ok := current.GetResponseContext(ctx)
	if ok && c != nil {
		_context = c
	}
	*resp = requestf.ResponsePacket{
		IVersion:     1,
		CPacketType:  0,
		IRequestId:   req.IRequestId,
		IMessageType: 0,
		IRet:         0,
		SBuffer:      tools.ByteToInt8(_os.ToBytes()),
		Status:       _status,
		SResultDesc:  "",
		Context:      _context,
	}
	return nil
}
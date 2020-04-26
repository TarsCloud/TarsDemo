const http = require('http');
const url = require('url');
const hostname = process.env.IP || '127.0.0.1';
const port = process.env.PORT || 3000;
const Tars = require('@tars/rpc').client;
const Demo = require('./nodeProxy').Demo;

const proxy = Tars.stringToProxy(Demo.HelloProxy, "Demo.NodejsTars.HelloObj");

const server = http.createServer(async(req, resp) => {
  var pathname = url.parse(req.url).pathname;
  console.log("Request for " + pathname + " received.");

  res = null;
  if (pathname == '/test/ping') {
    res = "pong";
  } else if (pathname == '/test/pingJs') {

    try {
      let data = await proxy.ping();
      res = data.response.return;

    }catch(e) {
      console.log(e);
      res = e.response.error.message;
    }
  }

  resp.writeHead(200, {
    "Content-Type": "text/plain"
  });
  resp.write(res ? res : "not found");
  resp.end();
});

server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});
const http = require('http');
const url = require('url');
var router = require("./router");
const hostname = process.env.IP || '127.0.0.1';
const port = process.env.PORT || 3000;
const server = http.createServer((req, resp) => {
  var pathname = url.parse(req.url).pathname;
  console.log("Request for " + pathname + " received.");

  res = router.route(pathname);

  resp.writeHead(200, {
    "Content-Type": "text/plain"
  });
  resp.write(res ? res : "Hello World");
  resp.end();
});

server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});
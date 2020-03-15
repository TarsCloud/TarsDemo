function route(pathname) {
    if (pathname == '/test/ping') {
        return "pong";
    }
    console.log("About to route a request for " + pathname);
}

exports.route = route;
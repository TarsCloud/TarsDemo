const Tars = require("@tars/rpc");
const App = require("./nodeImp.js").Demo;

const APP_NAME = "Demo",
  SERVER_NAME = "NodejsTars",
  OBJ_NAME = "HelloObj";
let servantName = `${APP_NAME}.${SERVER_NAME}.${OBJ_NAME}`;
let impMap = {
  [servantName]: App.HelloImp
};
Tars.server.getServant(process.env.TARS_CONFIG || `./${APP_NAME}.${SERVER_NAME}.config.conf`).forEach(function (config) {
  let svr = Tars.server.createServer(impMap[config.servant]);
  svr.start(config);
});
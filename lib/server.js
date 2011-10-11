var config, connect, details, dispatch, hostnames, num_servers, servers, u, vhosts;
require.paths.unshift(__dirname);
require.paths.unshift('/var/mtlfe/dispatch');
u = require('mtlfe/utilities');
config = require('mtlfe/config');
connect = require('connect');
servers = {};
num_servers = 0;
hostnames = [];
vhosts = config.vhosts.map(function(vhost) {
  var hostname, server_file;
  server_file = vhost.server_file;
  hostname = vhost.hostname;
  if (!servers[server_file]) {
    try {
      servers[server_file] = require(server_file);
    } catch (E) {
      console.log("E: " + E);
      servers[server_file] = connect(function(req, res, next) {
        return next(new Error("vhost crashed during config [" + server_file + "] " + E));
      });
    }
  }
  hostnames.push(hostname);
  vhost.server = connect.vhost(hostname, servers[server_file]);
  return vhost;
});
details = {
  servers: num_servers,
  vhosts: config.vhosts.length,
  hostnames: hostnames
};
dispatch = connect.createServer.apply(connect, vhosts.map(function(vhost) {
  return vhost.server;
}));
dispatch.details = details;
module.exports = dispatch.listen(config.port, '127.0.0.1', function() {
  console.log("[DISPATCH] Started listening on port http://" + config.hostname + ":" + config.port + " at " + (new Date()));
  return console.log("[DISPATCH:DETAILS] " + (JSON.stringify(details)));
});
var cluster, config, connect, details, dispatch, hostnames, num_servers, servers, u, vhosts;
require.paths.unshift(__dirname);
u = require('utilities');
config = require('config');
connect = require('connect');
cluster = require('cluster');
servers = {};
num_servers = 0;
hostnames = [];
vhosts = config.vhosts.map(function(vhost) {
  var hostname, server_file;
  server_file = vhost.server_file;
  hostname = vhost.hostname;
  if (!servers[server_file]) {
    servers[server_file] = require(server_file);
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
module.exports = cluster(dispatch).use(cluster.debug()).listen(config.port, config.hostname, function() {
  console.log("[DISPATCH] Started listening on port http://" + config.hostname + ":" + config.port + " at " + (new Date()));
  return console.log("[DISPATCH:DETAILS] " + (JSON.stringify(details)));
});
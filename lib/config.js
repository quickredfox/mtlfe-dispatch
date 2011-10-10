var fs, u;
require.paths.unshift(__dirname);
u = require('utilities');
fs = require('fs');
module.exports = (function(argv) {
  var arg, base_path, config, config_file, dispatch_host, dispatch_port;
  base_path = u.joinPath(__dirname, '..');
  while (arg = argv.shift()) {
    if (arg === '-c') {
      config_file = u.joinPath(argv.shift());
    }
    if (arg === '-p') {
      dispatch_port = parseFloat(argv.shift());
    }
    if (arg === '-h') {
      dispatch_host = parseFloat(argv.shift());
    }
  }
  config_file || (config_file = u.joinPath(base_path, 'config', 'dispatch.json'));
  config = u.readJSONSync(config_file);
  config.base = base_path;
  config.port = dispatch_port ? dispatch_port : 5000;
  config.hostname = dispatch_host ? dispatch_host : '127.0.0.1';
  config.vhosts_path || (config.vhosts_path = u.joinPath(base_path, 'vhosts'));
  config.vhosts = fs.readdirSync(config.vhosts_path).reduce(function(vhosts, dirname) {
    var aliases, hostname, path, server_file;
    path = u.joinPath(config.vhosts_path, dirname);
    aliases = [];
    hostname = dirname;
    if (/\.js/.test(dirname)) {
      hostname = dirname.replace(/.js/, '');
    }
    server_file = u.firstFileFoundSync(u.joinPath(path, 'server.js'), u.joinPath(path, 'app.js'), u.joinPath(path));
    if (!server_file) {
      throw new Error("No server file found for [" + hostname + "]");
    }
    try {
      aliases = u.readJSONSync(u.joinPath(path, 'aliases.json'));
    } catch (E) {

    } finally {
      aliases || (aliases = []);
    }
    aliases.unshift(hostname);
    return vhosts.concat(aliases.reduce(function(all, host) {
      all.push({
        base: path,
        hostname: host,
        server_file: server_file
      });
      if (!/\*/.test(host)) {
        all.push({
          base: path,
          hostname: "*." + host,
          server_file: server_file
        });
      }
      return all;
    }, []));
  }, []);
  config.vhosts.sort(function(a, b) {
    return b.hostname.length - a.hostname.length;
  });
  return config;
})(process.argv);
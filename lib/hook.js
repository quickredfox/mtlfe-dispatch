var arg, argv, config, connect, git, hostnames, port, u;
require.paths.unshift(__dirname);
require.paths.unshift('/var/mtlfe/dispatch');
u = require('mtlfe/utilities');
config = require('mtlfe/config');
git = require('mtlfe/git');
connect = require('connect');
hostnames = [];
port = 8888;
argv = Array.prototype.slice.call(process.argv );
console.log("ARGV " + process.argv);
while (arg = argv.shift()) {
  if (arg === '-p') {
    port = argv.shift();
  }
}
module.exports = connect(function(req, res, next) {
  return res.end(200);
});
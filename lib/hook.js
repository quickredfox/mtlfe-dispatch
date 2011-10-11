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
hooks.push(connect.vhost(config.hostname, fallback));
hooks.unshift(connect.logger());
hooks.unshift(connect.bodyParser());
hooks.unshift(function(req, res, next) {
  console.log(req);
  if (req.body && req.body.payload) {
    req.body.payload = JSON.parse(req.body.payload);
    return git.addRepo(req.body.payload.repository.name, "" + (req.body.payload.repository.url.replace(/\.git/, '')) + ".git", function(err) {
      return console.log(err);
    });
  } else {
    return res.end();
  }
});
module.exports = connect.apply(connect, hooks);
git.updateExistingRepos(function(errors) {
  if (errors) {
    throw errors;
  }
  console.log("Updated repos, Started listening on " + (hostnames.join(', ')) + " port " + port);
  return module.exports.listen(port);
});
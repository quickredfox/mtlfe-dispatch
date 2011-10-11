var arg, argv, config, connect, fallback, git, hooks, hostnames, port, syncRepo, u;
require.paths.unshift(__dirname);
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
syncRepo = function(req, next) {
  var cloneurl;
  cloneurl = "" + (req.body.payload.repository.url.replace(/\.git/, '')) + ".git";
  return git.addRepo(req.body.payload.name, cloneurl, function(err) {
    delete req.body.payload;
    return next(err);
  });
};
fallback = connect(connect.bodyParser(), function(req, res, next) {
  if (req.body.payload) {
    return syncRepo(req, next);
  } else {
    return next();
  }
});
hooks = config.dirs.map(function(hostname) {
  var path, server;
  hostnames.push(hostname);
  path = u.joinPath(config.vhosts_path, hostname);
  server = connect(connect.bodyParser(), function(req, res, next) {
    if (req.body && req.body.payload && /post/i.test(req.method)) {
      return syncRepo(req, next);
    } else {
      return next();
    }
  });
  return connect.vhost(hostname, server);
});
hooks.push(connect.vhost(config.hostname, fallback));
hooks.unshift(connect.logger());
module.exports = connect.apply(connect, hooks);
git.updateExistingRepos(function(errors) {
  if (errors) {
    throw errors;
  }
  console.log("Updated repos, Started listening on " + (hostnames.join(', ')) + " port " + port);
  return module.exports.listen(port);
});
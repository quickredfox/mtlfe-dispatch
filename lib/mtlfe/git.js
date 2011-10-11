var addRepo, config, connect, exec, fs, getLocalRepos, home, http, u, updateExistingRepos, updateRepo;
require.paths.unshift(__dirname);
u = require('utilities');
config = require('config');
fs = require('fs');
http = require('http');
connect = require('connect');
exec = require("child_process").exec;
home = process.cwd();
getLocalRepos = exports.getLocalRepos = function() {
  return fs.readdirSync(config.vhosts_path).reduce(function(repos, hostname) {
    var path, stat;
    path = u.joinPath(config.vhosts_path, hostname);
    stat = fs.statSync(path);
    if (stat.isDirectory()) {
      repos.push(path);
    }
    return repos;
  }, []);
};
addRepo = exports.addRepo = function(hostname, cloneurl, callback) {
  var local, path;
  path = u.joinPath(config.vhosts_path, hostname);
  local = getLocalRepos();
  if (local.indexOf(path) === -1) {
    return exec("git clone " + cloneurl + " " + path, function(error) {
      if (error) {
        return callback(new Error("Problem cloning repo [" + hostname + "] [" + cloneurl + "]; " + error));
      }
      return callback(null, true);
    });
  } else {
    return updateRepo(hostname, callback);
  }
};
updateRepo = exports.updateRepo = function(hostname, callback) {
  var path;
  path = u.joinPath(config.vhosts_path, hostname);
  process.chdir(path);
  return exec("git pull origin master", function(error) {
    if (error) {
      return callback(new Error("Problem updating repo [" + hostname + "] [" + path + "]; " + error));
    }
    return exec("git submodule foreach git pull", function(error) {
      process.chdir(home);
      if (error) {
        return callback(new Error("Problem updating submodule [" + hostname + "] [" + path + "]; " + error));
      }
      return callback(null, true);
    });
  });
};
updateExistingRepos = exports.updateExistingRepos = function(callback) {
  var end, errors, fns, start;
  console.time('updating repos');
  errors = [];
  end = function() {
    console.timeEnd('updating repos');
    return callback((errors.length > 0 ? errors : null), errors.length === 0);
  };
  fns = getLocalRepos().map(function(repo) {
    return function(fns) {
      process.chdir(repo);
      console.log("updating: " + repo);
      return exec('git pull origin master', function(error, stdout, stderr) {
        process.chdir(home);
        console.info("" + stdout + "\n" + stderr);
        try {
          if (error) {
            return errors.push(error);
          } else if (fns.length > 0) {
            return fns.shift()(fns);
          } else {
            return end();
          }
        } catch (E) {
          return errors.push(E);
        }
      });
    };
  }, []);
  if ((start = fns.shift())) {
    return start(fns);
  } else {
    return end('nothing to host');
  }
};
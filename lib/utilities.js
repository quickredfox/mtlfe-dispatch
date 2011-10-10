var firstDirFound, firstFileFound, fs, path;
fs = require('fs');
path = require('path');
exports.joinPath = function() {
  var parts;
  parts = Array.prototype.slice.call(arguments);
  return path.normalize(path.join.apply(path, parts));
};
exports.readJSON = function(file, callback) {
  return fs.readFile(file, 'utf8', function(E, content) {
    var error, json;
    error = function(E) {
      return callback(new Error("ERROR: JSON file [" + file + "] " + E));
    };
    if (E) {
      return error(E);
    }
    try {
      json = JSON.parse(content);
    } catch (E) {
      return error(E);
    }
    return callback(void 0, json);
  });
};
exports.readJSONSync = function(file) {
  var content, json;
  try {
    content = fs.readFileSync(file, 'utf8');
  } catch (E) {
    throw new Error("ERROR: JSON file [" + file + "] " + E);
  }
  try {
    json = JSON.parse(content);
  } catch (E) {
    throw new Error("ERROR: JSON file [" + file + "] " + E);
  }
  return json;
};
firstFileFound = function(files, callback, found) {
  var file;
  file = files.shift();
  if (!file) {
    if (!found) {
      return callback(new Error("no file found"));
    } else {
      return callback(void 0, found);
    }
  } else {
    return fs.stat(file, function(err, stat) {
      found = stat && stat.isFile() ? file : false;
      return recurseFind(files, callback, found);
    });
  }
};
exports.firstFileFound = function() {
  var callback, files;
  files = Array.prototype.slice.call(arguments);
  callback = files.pop();
  return firstFileFound(files, callback);
};
exports.firstFileFoundSync = function() {
  var file, files, stat;
  files = Array.prototype.slice.call(arguments);
  while (file = files.shift()) {
    try {
      stat = fs.statSync(file);
    } catch (E) {

    }
    if (stat && stat.isFile()) {
      return file;
    }
  }
  return null;
};
firstDirFound = function(dirs, callback, found) {
  var dir;
  dir = dirs.shift();
  if (!dir) {
    if (!found) {
      return callback(new Error("no dir found"));
    } else {
      return callback(void 0, found);
    }
  } else {
    return fs.stat(dir, function(err, stat) {
      found = stat && stat.isDirectory() ? dir : false;
      return recurseFind(dirs, callback, found);
    });
  }
};
exports.firstDirFound = function() {
  var callback, dirs;
  dirs = Array.prototype.slice.call(arguments);
  callback = dirs.pop();
  return firstdirFound(dirs, callback);
};
exports.firstDirFoundSync = function() {
  var dir, dirs, stat;
  dirs = Array.prototype.slice.call(arguments);
  while (dir = dirs.shift()) {
    try {
      stat = fs.statSync(dir);
    } catch (E) {

    }
    if (stat && stat.isDirectory()) {
      return dir;
    }
  }
  return null;
};
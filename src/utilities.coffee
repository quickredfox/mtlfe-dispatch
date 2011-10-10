fs   = require 'fs'
path = require 'path'

exports.joinPath = ()->
    parts = Array::slice.call( arguments )
    path.normalize path.join.apply path, parts


exports.readJSON = (file, callback)->
    fs.readFile file, 'utf8', (E, content)->
        error = (E)-> callback new Error "ERROR: JSON file [#{file}] #{E}"
        if E then return error(E)
        try
            json = JSON.parse content
        catch E 
            return error(E)
        return callback undefined, json

exports.readJSONSync = (file)->
    try
        content = fs.readFileSync file, 'utf8'
    catch E 
        throw new Error "ERROR: JSON file [#{file}] #{E}"
    try
        json    = JSON.parse content 
    catch E
        throw new Error "ERROR: JSON file [#{file}] #{E}"
    return json


firstFileFound = (files,callback,found)->
    file = files.shift()
    unless file 
        if not found then return callback new Error "no file found"
        else return callback undefined, found
    else
        fs.stat file, (err,stat)->
            found = if stat and stat.isFile() then file else false
            return recurseFind( files, callback, found )

exports.firstFileFound = ()->
    files    = Array::slice.call arguments
    callback = files.pop()
    firstFileFound( files, callback )

exports.firstFileFoundSync = ()->
    files  = Array::slice.call arguments
    while file = files.shift()
        try
            stat = fs.statSync( file )
        catch E
        return file if stat and stat.isFile()
    return null

firstDirFound = (dirs,callback,found)->
    dir = dirs.shift()
    unless dir 
        if not found then return callback new Error "no dir found"
        else return callback undefined, found
    else
        fs.stat dir, (err,stat)->
            found = if stat and stat.isDirectory() then dir else false
            return recurseFind( dirs, callback, found )

exports.firstDirFound = ()->
    dirs    = Array::slice.call arguments
    callback = dirs.pop()
    firstdirFound( dirs, callback )

exports.firstDirFoundSync = ()->
    dirs  = Array::slice.call arguments
    while dir = dirs.shift()
        try
            stat = fs.statSync( dir )
        catch E
        return dir if stat and stat.isDirectory()
    return null

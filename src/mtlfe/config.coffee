require.paths.unshift __dirname
u      = require 'utilities'
fs     = require 'fs'
module.exports = ((argv)->
    base_path = u.joinPath( __dirname, '..', '..' )
    while arg = argv.shift()
        if arg is '-c' then config_file   = u.joinPath argv.shift()
        if arg is '-p' then dispatch_port = parseFloat argv.shift()
        if arg is '-h' then dispatch_host = parseFloat argv.shift()
    config_file ||= u.joinPath( base_path, 'config', 'dispatch.json' )
    config = u.readJSONSync config_file
    config.base = base_path
    config.port = if dispatch_port then dispatch_port else 5000
    config.hostname = if dispatch_host then dispatch_host else '127.0.0.1'
    config.vhosts_path ||= u.joinPath( base_path, 'vhosts' )
    console.log config.vhosts_path
    config.dirs   = fs.readdirSync( config.vhosts_path )
    config.vhosts = config.dirs.reduce (vhosts,dirname)-> 
        path = u.joinPath( config.vhosts_path, dirname )
        aliases    = []
        hostname   = dirname
        if /\.js/.test dirname
            hostname    = dirname.replace /.js/, ''
        server_file = u.firstFileFoundSync u.joinPath( path, 'server.js' ), u.joinPath( path, 'app.js' ), u.joinPath( path )
        if !server_file then throw new Error "No server file found for [#{hostname}]"
        try
            aliases = u.readJSONSync  u.joinPath( path, 'aliases.json' )
        catch E
        finally
            aliases||= []
        aliases.unshift(hostname)
        vhosts.concat aliases.reduce (all,host)->
            all.push
                base:     path 
                hostname: host
                server_file:   server_file
            unless /\*/.test host
                all.push
                    base:     path 
                    hostname: "*.#{host}"
                    server_file:   server_file
            return all
        , []
    , []
    config.vhosts.sort (a,b)-> b.hostname.length - a.hostname.length 
    return config
)(Array::slice.call(process.argv))
require.paths.unshift __dirname
u       = require 'utilities'
config  = require 'config' 
connect = require 'connect'
servers     = {}
num_servers = 0
hostnames   = []
vhosts  = config.vhosts.map (vhost)-> 
    server_file = vhost.server_file
    hostname    = vhost.hostname
    unless servers[server_file] 
        servers[server_file] = require( server_file )
    hostnames.push hostname
    vhost.server = connect.vhost hostname, servers[server_file]
    return vhost
details = 
        servers:   num_servers
        vhosts:    config.vhosts.length
        hostnames: hostnames
dispatch = connect.createServer.apply( connect, vhosts.map (vhost)-> vhost.server )
module.exports = dispatch.listen config.port, config.hostname, ()->
    console.log "[DISPATCH] Started listening on port http://#{config.hostname}:#{config.port} at #{new Date()}"
    console.log "[DISPATCH:DETAILS] #{JSON.stringify(details)}"

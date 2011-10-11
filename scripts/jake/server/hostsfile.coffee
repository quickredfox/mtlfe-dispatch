fs      = require 'fs'
path    = require 'path'
require.paths.unshift path.normalize( path.join( __dirname, '..','..','..','src' )) 
config  = require 'config'
hostnames = {} 
c = fs.readFileSync '/etc/hosts', 'utf8'
fs.writeFileSync '/etc/hosts', c, 'utf8'
# config.vhosts.forEach (vhost)->
#     unless /\*/.test vhost.hostname
#         hostnames[vhost.hostname] = vhost.hostname
# hostnames = Object.keys(hostnames)
#     
# localizeHostnames = (hostnames)->
#     prefix = "# <localhost>\n# Dynamically managed.\n"
#     suffix = "# </localhost>"
#     begin_hosts_block = /(#[\s\t]+?\<localhost\>)/m
#     end_hosts_block   = /(#[\s\t]+?\<\/localhost\>)/m
#     try
#         contents = fs.readFileSync( '/etc/hosts', 'utf8' ).trim() 
#         start    = contents.match( begin_hosts_block ).index
#         match    = contents.match( end_hosts_block )
#         end      = (match.index + match[1].length)+1
# 
#         pre   = contents.substring 0, start
#         aft   = contents.substring end, contents.length
#         raw   = "#{pre}#{aft}\n" 
#         blk   = contents.substring start,end
#     catch E
#         raw = contents
#         hosts = []
#     hostnames = Array::slice.call(arguments).reduce (p,n)-> 
#         p.concat("127.0.0.1    #{n}")
#     , []
#     fs.writeFileSync '/etc/hosts', "#{raw}\n#{prefix}\n#{hostnames.join("\n") }\n#{suffix}".replace(/\n+/gm,"\n")
# 
# localizeHostnames.apply null, hostnames.reduce (names,name)->
#     names.push name unless /\*/.test name
#     return names
# , []
# 

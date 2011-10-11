require.paths.unshift __dirname
require.paths.unshift '/var/mtlfe/dispatch'
u       = require 'mtlfe/utilities'
config  = require 'mtlfe/config' 
git     = require 'mtlfe/git' 
connect = require 'connect'
hostnames = []
port      = 8888
argv = Array::slice.call( process.argv )
console.log "ARGV #{process.argv}"
while arg = argv.shift()
     if arg is '-p' then port = argv.shift()

# syncRepo = (req,next)->
#     cloneurl = "#{req.body.payload.repository.url.replace(/\.git/,'')}.git"
#     console.log "syncrepo #{req.body.payload.repository.name}"
#     git.addRepo req.body.payload.repository.name, cloneurl, (err)-> 
#         delete req.body.payload
#         next( err )  
          
# fallback = connect connect.bodyParser(), (req,res,next)->    
#         if req.body.payload then syncRepo( req, next ) else res.end()
#         
# hooks   = config.dirs.map (hostname)->
#     hostnames.push hostname
#     path = u.joinPath config.vhosts_path, hostname
#     server = connect (req,res,next)->
#         if req.body and req.body.payload
#             syncRepo( req, next ) 
#         else next()
#     connect.vhost( hostname, server )
    
hooks.push connect.vhost config.hostname, fallback

hooks.unshift connect.logger()
hooks.unshift connect.bodyParser()
hooks.unshift (req,res,next)->
    console.log req
    if req.body and req.body.payload
        req.body.payload = JSON.parse( req.body.payload )
        git.addRepo req.body.payload.repository.name, "#{req.body.payload.repository.url.replace(/\.git/,'')}.git", (err)-> console.log( err )
    else res.end()

module.exports = connect.apply( connect, hooks )

git.updateExistingRepos (errors)-> 
    if errors then throw errors
    console.log "Updated repos, Started listening on #{ hostnames.join(', ') } port #{port}"
    module.exports.listen(port)

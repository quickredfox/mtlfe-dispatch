require.paths.unshift __dirname
u       = require 'mtlfe/utilities'
config  = require 'mtlfe/config' 
git     = require 'mtlfe/git' 
connect = require 'connect'
syncRepo = (req,next)->
    cloneurl = "#{req.body.payload.repository.url.replace(/\.git/,'')}.git"
    git.addRepo req.body.payload.name, cloneurl, (err)-> 
        delete req.body.payload
        next( err )    
fallback = connect connect.bodyParser(), (req,res,next)->    
        if req.body.payload then syncRepo( req, next ) else next()
hooks   = config.dirs.map (hostname)->
    path = u.joinPath config.vhosts_path, hostname
    server = connect connect.bodyParser()  , (req,res,next)->
        if req.body and req.body.payload and /post/i.test req.method
            cloneurl = "#{req.body.payload.repository.url.replace(/\.git/,'')}.git"
            git.addRepo hostname, cloneurl, (err)-> 
                delete req.body.payload
                next( err )
        else next()
    connect.vhost( hostname, server )
hooks.push connect.vhost config.hostname, fallback

git.updateExistingRepos (errors)->
    if errors then throw errors
    connect.apply( connect, hooks ).listen(6666)

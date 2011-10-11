require.paths.unshift __dirname
u       = require 'utilities'
config  = require 'config' 
fs      = require 'fs'
http    = require 'http'
connect = require 'connect'
exec    = require("child_process").exec
home    = process.cwd()
getLocalRepos = exports.getLocalRepos = ()-> 
    fs.readdirSync(config.vhosts_path).reduce (repos,hostname)->
        path = u.joinPath config.vhosts_path, hostname
        stat = fs.statSync path
        if stat.isDirectory()
            repos.push path
        return repos
    , []

addRepo = exports.addRepo = (hostname,cloneurl,callback)->
    path  = u.joinPath config.vhosts_path, hostname
    local = getLocalRepos()
    if local.indexOf( path ) is -1
        exec "git clone #{cloneurl} #{path}", (error)->
            if error then return callback( new Error "Problem cloning repo [#{hostname}] [#{cloneurl}]; #{error}")
            return callback null, true
    else
        updateRepo( hostname, callback )
    
updateRepo = exports.updateRepo = (hostname,callback)->
    path  = u.joinPath config.vhosts_path, hostname
    process.chdir(path)
    exec "git pull origin master", (error)->
        if error then return callback( new Error "Problem updating repo [#{hostname}]; #{error}")
        exec "git submodule foreach git pull", (error)->
            process.chdir( home )
            if error then return callback( new Error "Problem updating submodule [#{hostname}]; #{error}")
            callback null, true

updateExistingRepos = exports.updateExistingRepos = (callback)->     
    console.time 'updating repos'
    errors = []
    end = ()-> 
        console.timeEnd 'updating repos'
        callback ( if errors.length > 0 then errors else null ), errors.length is 0
    fns = getLocalRepos().map (repo)->
        (fns)->
            process.chdir repo
            console.log "updating: #{repo}"
            exec 'git pull origin master', (error,stdout,stderr)->
                process.chdir( home )
                console.info "#{stdout}\n#{stderr}"
                try
                    if error then errors.push(error)
                    else if fns.length > 0 then fns.shift()(fns)
                    else end()
                catch E
                    errors.push E
                
    , [ ]
    if (start = fns.shift()) then start(fns) else end('nothing to host')
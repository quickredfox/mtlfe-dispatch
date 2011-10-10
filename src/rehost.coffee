require.paths.unshift __dirname
u       = require 'utilities'
fs   = require 'fs'


getHostsFileLines = ()->
    file = './hosts'
    fs.readFileSync( file, 'utf8' ).trim().split(/\n/)
    
readHosts = ()->
    lines     = getHostsFileLines()
    hosts     = lines.reduce (hosts,line,index)->
        if /^#?[\d\.]+\s/.test line
            last = if (idx = line.lastIndexOf('#')-1 ) <= 0  then line.length else idx
            data = line.substring(0,last).trim().split(/[\s\t]+/g)
            hosts.push 
                line: index
                ip:   data.shift()
                hostnames: data
                linecomment: if idx > 0 then line.substring(line.lastIndexOf('#'),line.length) else null
        return hosts
    , []
    meta = lastLine: lines.length
    findByIP = (ip)->
        hosts.reduce (found,item)->
            value = item.ip.replace(/\#/,'')
            if value is ip then found.push item
            return found
        , []
    findByHostname =     (hostname)->
            hosts.reduce (found,item)->
                if item.hostnames.indexOf(hostname) isnt -1 then found.push item
                return found
            , []
    add = (ip,hostname,linecomment=null)->
        ip_is   = findByIP(ip)
        host_is = findByHostname(hostname)
        if host_is.length > 0 then throw new Error "Hostname [#{hostname}] already bound to [#{host_is[0].ip}]"
        if ip_is.length > 0
            item = ip_is[ip_is.length-1]
            item.hostnames.push hostname
        else
            hosts.push
                line: meta.lastLine++
                ip: ip
                hostnames: [hostname]
                linecomment: linecomment
    toggleIP = (ip)->
        ip_is = findByIP(ip)
        hosts = hosts.map (host)->
            value = host.ip.replace(/\#/,'')
            if value is ip then host.ip = "##{host.ip}"
            return host
    removeHostname = (hostname)->
        host_is = findByHostname(hostname)
        hosts = hosts.map (host)->
            if host.hostnames.indexOf( hostname ) > -1
                host.hostnames = host.hostnames.reduce (all,item)->
                    if item isnt hostname then all.push item
                    return all
                , [] 
            return host
    remove = (ip_or_hostname)->
        if /^[0-255]+/.test ip_or_hostname then removeIP( ip_or_hostname ) else removeHostname( ip_or_hostname )
    result=
        hosts: hosts
        meta: meta
        findByIP: findByIP
        findByHostname: findByHostname
        add: add
        remove: remove
    return result
hosts = readHosts()
hosts.add('192.168.1.1','tabarnak')
hosts.add('192.168.1.1','joe')

hosts.remove('192.168.1.1')
console.log hosts.hosts


var http = require('http');
throw "WEr"
server= http.createServer(function (req, res) {
  server.close()
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end('Goodbye World\n');
})


module.exports = server
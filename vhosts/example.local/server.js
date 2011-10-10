var connect = require('connect');
module.exports = connect.createServer(function (req, res) {
  console.log(req.method, req.url);
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end('Hello World\n');
})


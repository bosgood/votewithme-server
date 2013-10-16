io = require 'socket.io'
http = require 'http'
express = require 'express'
app = express()
port = process.env.PORT or 3000

db = require('./db').connect()
API = require('./api')
api = new API(db)
server = http.createServer(app)
server.listen(port)

console.log "voting server started on port #{port}"
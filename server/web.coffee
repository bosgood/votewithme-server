io = require 'socket.io'
http = require 'http'
express = require 'express'
app = express()
port = process.env.PORT || 3000

db = require('./db').connect()

server = http.createServer(app)
server.listen(port)

console.log "voting server started on port #{port}"
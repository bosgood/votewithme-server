# Main web server definition

io = require 'socket.io'
http = require 'http'
express = require 'express'
app = express()
port = process.env.PORT or 3000

app.use(express.logger())
app.use(express.compress())
app.use(express.json())
app.use(express.urlencoded())
app.use(express.methodOverride())
app.use(app.router)

db = require('./db').connect()
API = require('./api')
api = new API(db)

# Initialize routing for REST API
rest = require './rest'
rest.init(app, api)

server = http.createServer(app)
server.listen(port)

console.log "voting server started on port #{port}"
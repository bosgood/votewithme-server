# Main web server definition
db = require('./db').connect()
db.connection.on 'connected', ->
  try
    # Initialize routing for REST API
    http = require './http2'
    http.init(process.env.PORT or 3000)

    # Initialize realtime events support
    realtime = require './realtime'
    realtime.init()
  catch e
    console.error(e.stack)
    process.exit(1)
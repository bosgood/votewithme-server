# Main web server definition
db = require('./db').connect()
db.on 'connected', ->
  API = require('./api')
  api = new API(db)

  # Initialize routing for REST API
  http = require './http'
  http.init(api, process.env.PORT or 3000)

  # Initialize realtime events support
  realtime = require './realtime'
  realtime.init()
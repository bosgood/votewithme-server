# Main web server definition
db = require('./db').connect()
db.on 'connected', ->
  InternalApi = require('./api')
  api = new InternalApi(db)

  # Initialize routing for REST API
  http = require './http'
  http.init(api, process.env.PORT or 3000)

  # Initialize realtime events support
  realtime = require './realtime'
  realtime.init()
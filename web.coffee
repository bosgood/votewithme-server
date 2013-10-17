# Main web server definition

db = require('./db').connect()
API = require('./api')
api = new API(db)

# Initialize routing for REST API
rest = require './rest'
rest.init(api, process.env.PORT or 3000)

# Initialize realtime events support
realtime = require './realtime'
realtime.init()
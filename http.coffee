# API endpoints setup

express = require 'express'

init = (port) ->
  console.log "[HTTP] initializing express"

  app = express()
  app.use(express.logger())
  app.use(express.compress())
  app.use(express.json())
  app.use(express.urlencoded())
  app.use(express.methodOverride())
  app.use(app.router)

  resources = getResources()
  console.log "[HTTP] found #{resources.length} resource types"
  for resource in resources
    console.log "[HTTP] initializing resource: #{resource.resourceName}"
    resource.initialize(app)

  app.listen(port)
  console.log "[HTTP] listening on port #{port}"

getResources = -> [
  require('./resources/votes')
  require('./resources/users')
  require('./resources/competitions')
  require('./resources/competition_candidates')
  require('./resources/competition_memberships')
  require('./resources/choices')
]

module.exports = {init}
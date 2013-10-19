express = require 'express'

# Defines an HTTP API implemented with Express
class HttpApi
  constructor: (@port) ->
    throw new Error('must provide port') unless @port?

  # Enumerate all endpoints here as HttpApiEndpoint object instances
  endpoints: -> []

  init: (@api) ->
    throw new Error('must provide internal api') unless @api?
    console.log "[HTTP] initializing express"

    @app = express()
    @app.use(express.logger())
    @app.use(express.compress())
    @app.use(express.json())
    @app.use(express.urlencoded())
    @app.use(express.methodOverride())
    @app.use(@app.router)

    for [route, method, handler] in @endpoints()
      console.log "[HTTP] adding endpoint: #{method.toUpperCase()} #{route}"
      endpoint = new HttpApiEndpoint(handler)
      @app[method](route, endpoint.getRouteHandler(@api))

    @app.listen(@port)
    console.log "[HTTP] listening on port #{@port}"
    @

# Defines an individual endpoint in an API
class HttpApiEndpoint
  constructor: (@handler) ->
    throw new Error('must provide a handler') unless @handler?

  getRouteHandler: (@api) ->
    throw new Error('must provide internal api') unless @api?
    return (req, res) =>
      @handler.call(@, req, res)

  # Creates an object suitable for use with paged UIs
  _createDataPage: (dataArray, offset = 0, limit = -1) ->
    return {
      totalCount: dataArray.length
      count: dataArray.length
      offset: offset
      limit: limit
      objects: dataArray
    }

  listSingle: (query, options) ->

# createEndpoint = (handler) ->
#   # class endPoint extends HttpApiEndpoint
#   return new HttpApiEndpoint(handler)

module.exports = {HttpApi, HttpApiEndpoint}
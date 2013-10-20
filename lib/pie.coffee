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
      @app[method.toLowerCase()](route, endpoint.getRouteHandler(@api))

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

  parseObjectId: (req, urlPrefix) ->
    req.url.replace("/#{urlPrefix}/", '')

  # Creates an object suitable for use with paged UIs
  createDataPage: (dataArray, offset = 0, limit = -1) ->
    return {
      totalCount: dataArray.length
      count: dataArray.length
      offset: offset
      limit: limit
      objects: dataArray
    }

  listAny: (res, promise, options, packageData, emptyResult) ->
    promise
    .then((results) ->
      if results?.length
        console.log "[HTTP] 200: found #{results.length} #{options.typeName}"
        res.json(200, packageData(results))
      else
        if options.query
          console.log "[HTTP] 404: no #{options.typeName} found for query:", options.query
        else
          console.log "[HTTP] 404: no #{options.typeName} found"
        res.json(404, emptyResult)
    )
    .fail((err) =>
      @handleApiError(res, err, errorMsg: "failed to list #{options.typeName}")
    )
    .done()

  handleApiError: (res, err, options) ->
    errorMsg = if options.errorMsg then "#{options.errorMsg}." else ''
    errorCode = options.errorCode or 500
    console.error("[HTTP] #{errorCode}: #{errorMsg}")
    console.error(err.stack)
    res.json(errorCode, { error: errorMsg })

  listSingle: (res, promise, options) ->
    packageData = (results) -> results[0]
    @listAny(res, promise, options, packageData, {})

  listMultiple: (res, promise, options) ->
    packageData = (results) => @createDataPage(results)
    @listAny(res, promise, options, packageData, [])

module.exports = {HttpApi, HttpApiEndpoint}
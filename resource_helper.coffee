ExpressHttpResource = require 'bloops/adapters/express_resource'
MongooseAdapter = require 'bloops/adapters/mongoose_adapter'
models = require('./db').models
filters = require 'bloops/filters'

cors = require 'cors'

class BaseResource extends ExpressHttpResource
  adapter: MongooseAdapter
  context:
    models: models

class Resource extends BaseResource
  willAddEndpoint: (app, route, method, handler) ->
    # Enable a pre-flight OPTIONS request
    app.options(route, cors())

  getMiddleware: ->
    [cors()]

module.exports = {Resource, models, filters}
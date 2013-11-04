ExpressHttpResource = require 'bloops/adapters/express_resource'
MongooseAdapter = require 'bloops/adapters/mongoose_adapter'
models = require('./db').models
filters = require 'bloops/filters'

class Resource extends ExpressHttpResource
  adapter: MongooseAdapter
  context:
    models: models

module.exports = {Resource, models, filters}
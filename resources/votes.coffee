# resourceful model definition
HttpResource = require '../bloops/resource'
MongooseAdapter = require '../bloops/mongoose_adapter'
Vote = require('../db').models.vote

class VoteResource extends HttpResource
  resourceName: 'votes'
  additionalEndpoints: null
  adapter: new MongooseAdapter
  model: Vote

module.exports = VoteResource
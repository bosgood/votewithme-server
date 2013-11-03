ExpressHttpResource = require '../bloops/adapters/express_resource'
MongooseAdapter = require '../bloops/adapters/mongoose_adapter'
Vote = require('../db').models.vote

VoteResource = new ExpressHttpResource
  resourceName: 'votes'
  adapter: new MongooseAdapter(Vote)
  model: Vote

module.exports = VoteResource
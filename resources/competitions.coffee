ExpressHttpResource = require '../bloops/adapters/express_resource'
MongooseAdapter = require '../bloops/adapters/mongoose_adapter'
Competition = require('../db').models.competition

CompetitionResource = new ExpressHttpResource
  resourceName: 'competitions'
  adapter: new MongooseAdapter(Competition)
  model: Competition

module.exports = CompetitionResource
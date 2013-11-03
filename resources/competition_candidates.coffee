ExpressHttpResource = require '../bloops/adapters/express_resource'
MongooseAdapter = require '../bloops/adapters/mongoose_adapter'
Candidate = require('../db').models.competition_candidate

CandidateResource = new ExpressHttpResource
  resourceName: 'candidates'
  adapter: new MongooseAdapter(Candidate)
  model: Candidate

module.exports = CandidateResource
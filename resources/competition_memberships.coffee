ExpressHttpResource = require '../bloops/adapters/express_resource'
MongooseAdapter = require '../bloops/adapters/mongoose_adapter'
Membership = require('../db').models.competition_membership

MembershipResource = new ExpressHttpResource
  resourceName: 'memberships'
  adapter: new MongooseAdapter(Membership)
  model: Membership

module.exports = MembershipResource
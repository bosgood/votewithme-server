ExpressHttpResource = require '../bloops/adapters/express_resource'
MongooseAdapter = require '../bloops/adapters/mongoose_adapter'
User = require('../db').models.user

UserResource = new ExpressHttpResource
  resourceName: 'users'
  adapter: new MongooseAdapter(User)
  model: User

module.exports = UserResource
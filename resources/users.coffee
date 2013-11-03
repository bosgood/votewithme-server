{models, Resource, filters} = require '../resource_helper'

UserResource = new Resource
  resourceName: 'users'
  model: models.user

module.exports = UserResource
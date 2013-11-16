{models, Resource, filters} = require '../resource_helper'

UserResource = new Resource
  resourceNameMany: 'users'
  resourceNameOne: 'user'
  model: models.user

module.exports = UserResource
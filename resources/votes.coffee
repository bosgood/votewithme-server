{models, Resource, filters} = require '../resource_helper'

VoteResource = new Resource
  resourceName: 'votes'
  model: models.vote

module.exports = VoteResource
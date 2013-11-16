{models, Resource, filters} = require '../resource_helper'

VoteResource = new Resource
  resourceNameMany: 'votes'
  resourceNameOne: 'vote'
  model: models.vote

module.exports = VoteResource
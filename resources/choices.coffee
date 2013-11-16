{models, Resource, filters} = require '../resource_helper'

ChoiceResource = new Resource
  resourceNameMany: 'choices'
  resourceNameOne: 'choice'
  model: models.choice

module.exports = ChoiceResource
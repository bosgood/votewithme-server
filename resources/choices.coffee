{models, Resource, filters} = require '../resource_helper'

ChoiceResource = new Resource
  resourceName: 'choices'
  model: models.choice

module.exports = ChoiceResource
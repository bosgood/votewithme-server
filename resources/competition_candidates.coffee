{models, Resource, filters} = require '../resource_helper'

CandidateResource = new Resource
  resourceName: 'candidates'
  model: models.competition_candidate

module.exports = CandidateResource
{models, Resource, filters} = require '../resource_helper'

CandidateResource = new Resource
  resourceNameMany: 'candidates'
  resourceNameOne: 'candidate'
  model: models.competition_candidate

module.exports = CandidateResource
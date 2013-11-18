{models, Resource, filters} = require '../resource_helper'

crud = require 'bloops/crud'
errors = require 'bloops/errors'

ChoiceResource = new Resource
  resourceNameMany: 'choices'
  resourceNameOne: 'choice'
  model: models.choice

  getEndpoints: -> [
    'show'
    'update'
    'destroy'
    'patch'
    'index'
    create
    getByCompetition
  ]

create =

_baseCreate = crud.create.handler
create =
  route: '/'
  method: ['POST', 'PUT']
  filters: [filters.FromJson]
  handler: ->
    unless @params.name? and @params.competition_id?
      throw new errors.UserError('must provide name and competition_id')
    _baseCreate.call(@)

getByCompetition =
  route: '/by-competition/:competitionId'
  method: 'GET'
  filters: [filters.FromUrlParams]
  handler: ->
    competitionId = @params.competition_id
    unless competitionId
      throw new errors.UserError('must provide competition_id')

    @api.list competition_id: competitionId

module.exports = ChoiceResource
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
    unless @params.name? and @params.competitionId?
      throw new errors.UserError('must provide name and competitionId')
    _baseCreate.call(@)

getByCompetition =
  route: '/by-competition/:competitionId'
  method: 'GET'
  filters: [filters.FromUrlParams]
  handler: ->
    competitionId = @params.competitionId
    unless competitionId
      throw new errors.UserError('must provide competitionId')

    @api.list competition_id: competitionId

module.exports = ChoiceResource
{models, Resource, filters} = require '../resource_helper'

crud = require 'bloops/crud'
errors = require 'bloops/errors'

VoteResource = new Resource
  resourceNameMany: 'votes'
  resourceNameOne: 'vote'
  model: models.vote

  getEndpoints: -> [
    'show'
    'update'
    'destroy'
    'patch'
    'index'
    create
    getByCompetition
  ]

_baseCreate = crud.create.handler
create =
  route: '/'
  method: ['POST', 'PUT']
  filters: [filters.FromJson]
  handler: ->
    @params.quantity ?= 1
    unless @params.choiceId? and @params.competitionId? and @params.userId?
      throw new errors.UserError('must provide choiceId, competitionId and userId')

    @params.competition_id = @params.competitionId
    delete @params.competitionId
    @params.choice_id = @params.choiceId
    delete @params.choiceId
    @params.user_id = @params.userId
    delete @params.userId

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

module.exports = VoteResource
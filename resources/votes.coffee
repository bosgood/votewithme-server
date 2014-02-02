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
    getByUser
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

getByUser =
  route: '/by-user/:userId'
  method: 'GET'
  filters: [filters.FromUrlParams]
  handler: ->
    userId = @params.userId
    unless userId
      throw new errors.UserError('must provide userId')

    @api.list user_id: userId

module.exports = VoteResource
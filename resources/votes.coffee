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
    unless @params.choice_id? and @params.competition_id? and @params.user_id?
      throw new errors.UserError('must provide choice_id, competition_id and user_id')
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
    userId = @params.user_id
    unless userId
      throw new errors.UserError('must provide user_id')

    @api.list user_id: userId

module.exports = VoteResource
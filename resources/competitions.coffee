{models, Resource, filters} = require '../resource_helper'
FromJson = filters.FromJson
FromUrlParams = filters.FromUrlParams

class CompetitionResource extends Resource
  resourceName: 'competitions'
  model: models.competition

  getEndpoints: -> [
    getByOwner
    'index'
    'show'
    'update'
    'destroy'
    'create'
    'patch'
  ]

#
# Custom endpoints defined here
#
getByOwner =
  route: '/by-owner/:ownerId'
  method: 'GET'
  filters: [FromUrlParams]
  emptyResult: []
  handler: ->
    @api.find(owner_id: @params.ownerId)

module.exports = new CompetitionResource
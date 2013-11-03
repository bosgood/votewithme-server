{models, Resource, filters} = require '../resource_helper'

class CompetitionResource extends Resource
  resourceName: 'competitions'
  model: models.competition

  getEndpoints: -> [
    getByOwner
    index
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
  filters: [filters.FromUrlParams, filters.FromQueryParams]
  emptyResult: []
  handler: ->
    ownerId = @params.ownerId
    showClosed = @params.showClosed
    query =
      owner_id: ownerId
    unless showClosed == 'true' or showClosed == true
      query.open = true
    console.log "[HTTP] request to list competitions by owner (ownerId=#{ownerId}, showClosed=#{showClosed})"
    @api.find(query)

index =
  route: '/'
  method: 'GET'
  filters: [filters.FromUrlParams, filters.FromQueryParams]
  emptyResult: []
  handler: ->
    showClosed = @params.showClosed
    query = {}
    unless showClosed == 'true' or showClosed == true
      query.open = true
    console.log "[HTTP] request to list competitions (showClosed=#{showClosed})"
    @api.find(query)

module.exports = new CompetitionResource
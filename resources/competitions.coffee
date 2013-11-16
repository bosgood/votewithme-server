Q = require 'q'
{models, Resource, filters} = require '../resource_helper'
errors = require 'bloops/errors'

class CompetitionResource extends Resource
  resourceNameMany: 'competitions'
  resourceNameOne: 'competition'
  model: models.competition

  getEndpoints: -> [
    getByOwner
    index
    getByMembership
    end
    restart
    start
    'show'
    'update'
    'destroy'
    # 'create'
    # 'patch'
  ]

#
# Custom endpoints defined here
#
getByOwner =
  route: '/by-owner/:ownerId'
  method: 'GET'
  filters: [filters.FromUrlParams, filters.FromQueryParams]
  handler: ->
    ownerId = @params.ownerId
    showClosed = @params.showClosed
    query =
      owner_id: ownerId
    unless showClosed == 'true' or showClosed == true
      query.open = true
    console.log "[HTTP] request to list competitions by owner (ownerId=#{ownerId}, showClosed=#{showClosed})"
    @api.list(query)

index =
  route: '/'
  method: 'GET'
  filters: [filters.FromUrlParams, filters.FromQueryParams]
  handler: ->
    showClosed = @params.showClosed
    query = {}
    unless showClosed == 'true' or showClosed == true
      query.open = true
    console.log "[HTTP] request to list competitions (showClosed=#{showClosed})"
    @api.list(query)

getByMembership =
  route: '/by-membership/:userId'
  method: 'GET'
  filters: [filters.FromUrlParams, filters.FromQueryParams]
  handler: ->
    userId = @params.userId
    showClosed = @params.showClosed == 'true' or @params.showClosed == true
    competitionsQuery = {}
    membershipApi = @createApi(@adapter, @models.competition_membership)
    console.log "[HTTP] request to list competitions by membership (userId=#{userId}, showClosed=#{showClosed})"
    membershipApi.list(user_id: userId)
    .then((memberships) =>
      if memberships?.length == 0
        console.log "[HTTP] found no competition memberships (userId=#{userId})"
        return []

      ownerOrMatchesMembership = memberships.map((membership) ->
        _id: membership.competition_id
      )
      ownerOrMatchesMembership.push({ owner_id: userId })
      condition = { $or: ownerOrMatchesMembership }
      dbQuery = @model.find(condition)
      unless showClosed
        dbQuery.where('open').equals(true)
      Q(dbQuery.exec())
    )

end =
  route: '/:id/end'
  filters: [filters.FromUrlParams]
  method: 'POST'
  handler: ->
    competitionId = @params.id
    console.log "[HTTP] end competition (competitionId=#{competitionId})"
    @api.update(
      { _id: competitionId },
      { open: false }
    )

restart =
  route: '/:id/restart'
  filters: [filters.FromUrlParams]
  method: 'POST'
  handler: ->
    competitionId = @params.id
    console.log "[HTTP] start competition (competitionId=#{competitionId})"
    @api.update(
      { _id: competitionId },
      { open: true }
    )

start =
  route: '/'
  filters: [filters.FromJson]
  method: 'POST'
  handler: ->
    ownerId = @params.ownerId
    name = @params.name
    unless ownerId? and name?
      throw new errors.UserError('must provide name and ownerId')

    @context.statusCode = 201
    @api.create
      owner_id: ownerId
      name: name
      open: true
      type: 'multi'

module.exports = new CompetitionResource
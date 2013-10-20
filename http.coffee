Q = require 'q'
pie = require './lib/pie'

# API endpoints setup
init = (api, port) ->
  votingApi = new VotingHttpApi(port)
  votingApi.init(api)

class VotingHttpApi extends pie.HttpApi
  endpoints: -> [
    ['/user/:userId', 'GET', listUser]
    ['/users', 'GET', listUsers]
    ['/user', 'POST', createUser]
    ['/competition/:competitionId', 'GET', listCompetition]
    ['/competitions/by-owner/:ownerId', 'GET', listCompetitionsByOwner]
    ['/competitions/by-membership/:userId', 'GET', listCompetitionsByMembership]
    ['/competitions/memberships', 'GET', listCompetitionMemberships]
    ['/competitions/all', 'GET', listCompetitions]
    ['/competitions', 'GET', listCompetitions]
    ['/competition/:competitionId/end', 'POST', endCompetition]
    ['/competition/:competitionId/join', 'POST', joinCompetition]
    ['/competition/:competitionId/withdraw', 'POST', withdrawFromCompetition]
    ['/competition/:competitionId/memberships', 'GET', listCompetitionMemberships]
    ['/competition', 'POST', startCompetition]
  ]

# Endpoint handler methods

# Lists one user
listUser = (req, res) ->
  userId = req.params.userId
  console.log "[HTTP] request to list user (userId=#{userId})"
  if not userId
    res.json(400, {message: "must provide userId"})
    return

  @listSingle(
    res,
    @api.listUsers(userId),
    { typeName: 'user', query: { user_id: userId } }
  )

# Lists all users
listUsers = (req, res) ->
  @listMultiple(
    res,
    @api.listUsers(),
    { typeName: 'users' }
  )

createUser = (req, res) ->
  @api.createUser(req.body.name)
  .then((user) ->
    res.json(201, user)
    console.log("[HTTP] 201: created user: #{user}")
  )
  .fail((err) =>
    @handleApiError(
      res,
      err,
      errorMsg: "failed to create user"
    )
  )
  .done()

listCompetition = (req, res) ->
  competitionId = req.params.competitionId
  if not competitionId
    res.json(400, {message: "must provide competitionId"})
    return

  @listSingle(
    res,
    @api.listCompetitions(competitionId),
    { typeName: 'competition', query: { competition_id: competitionId } }
  )

listCompetitions = (req, res) ->
  @listMultiple(
    res,
    @api.listCompetitions(),
    { typeName: 'competitions' }
  )

listCompetitionsByOwner = (req, res) ->
  @listMultiple(
    res,
    @api.listCompetitionsByOwner(req.params.ownerId),
    { typeName: 'competitions' }
  )

listCompetitionsByMembership = (req, res) ->
  @listMultiple(
    res,
    @api.listCompetitionsByMembership(req.params.userId),
    { typeName: 'competitions' }
  )

listCompetitionMemberships = (req, res) ->
  if req.params.competitionId?
    competitionId = req.params.competitionId
  @listMultiple(
    res,
    @api.listCompetitionMemberships(competitionId),
    { typeName: 'competition memberships' }
  )

startCompetition = (req, res) ->
  @api.startCompetition(req.body.userId, req.body.name)
  .then((competition) ->
    res.json(201, competition)
    console.log("[HTTP] 201: started competition: #{competition}")
  )
  .fail((err) =>
    @handleApiError(
      res,
      err,
      errorMsg: "failed to start competition"
    )
  )
  .done()

endCompetition = (req, res) ->
  @api.endCompetition(req.params.competitionId)
  .then((competition) ->
    res.json(200, competition)
    console.log "[HTTP] 200: ended competition: #{competition}"
  )
  .fail((err) =>
    @handleApiError(
      res,
      err,
      errorMsg: "failed to end competition"
    )
  )
  .done()

joinCompetition = (req, res) ->
  @api.joinCompetition(req.body.userId, req.params.competitionId)
  .then((competitionMembership) ->
    res.json(201, competitionMembership)
    console.log("[HTTP] 201: joined competition: #{competitionMembership}")
  )
  .fail((err) =>
    @handleApiError(
      res,
      err,
      errorMsg: "failed to join competition"
    )
  )
  .done()

withdrawFromCompetition = (req, res) ->
  userId = req.body.userId
  competitionId = req.params.competitionId

  @api.withdrawFromCompetition(userId, competitionId)
  .then((props) ->
    res.json(200, props)
    console.log "[HTTP] 200: withdrew from competition (userId=#{props.userId}, competitionId=#{props.competitionId})"
  )
  .fail((err) =>
    @handleApiError(
      res,
      err,
      errorMsg: "failed to withdraw from competition (userId=#{userId}, competitionId=#{competitionId})"
    )
  )

module.exports = {init}
Q = require 'q'
pie = require './lib/pie'

# API endpoints setup
init = (api, port) ->
  votingApi = new VotingHttpApi(port)
  votingApi.init(api)

class VotingHttpApi extends pie.HttpApi
  endpoints: -> [
    ['/user/:userId', 'get', listUser]
    ['/users', 'get', listUsers]
    ['/user', 'post', createUser]
    ['/competition/:competitionId', 'get', listCompetition]
    ['/competitions/by-owner/:ownerId', 'get', listCompetitionsByOwner]
    ['/competitions/by-membership/:userId', 'get', listCompetitionsByMembership]
    ['/competitions/memberships', 'get', listCompetitionMemberships]
    ['/competitions/all', 'get', listCompetitions]
    ['/competitions', 'get', listCompetitions]
    ['/competition/:competitionId/end', 'post', endCompetition]
    ['/competition/:competitionId/join', 'post', joinCompetition]
    ['/competition/:competitionId/withdraw', 'post', withdrawFromCompetition]
    ['/competition/:competitionId/memberships', 'get', listCompetitionMemberships]
    ['/competition', 'post', startCompetition]
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
  .fail((err) ->
    errorMsg = "failed to create user. reason: #{err}"
    res.json(500, {error: errorMsg})
    console.error("[HTTP] 500: #{errorMsg}")
    console.error(err.stack)
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

listCompetitionsByMembership = (req, res) ->
  @listMultiple(
    res,
    @api.listCompetitionsByMembership(req.body.userId),
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
  .fail((err) ->
    errorMsg = "failed to start competition. reason: #{err}"
    res.json(500, {error: errorMsg})
    console.error("[HTTP] 500: #{errorMsg}")
    console.error(err.stack)
  )
  .done()

endCompetition = (req, res) ->
  @api.endCompetition(req.body.competitionId)
  .then((competition) ->
    res.json(200, competition)
    console.log "[HTTP] 200: ended competition: #{competition}"
  )
  .fail((err) ->
    errorMsg = "failed to end competition. reason: #{err}"
    res.json(500, {error: errorMsg})
    console.error("[HTTP] 500: #{errorMsg}")
    console.error(err.stack)
  )
  .done()

joinCompetition = (req, res) ->
  @api.joinCompetition(req.body.userId, req.body.competitionId)
  .then((competitionMembership) ->
    res.json(201, competitionMembership)
    console.log("[HTTP] 201: joined competition: #{competitionMembership}")
  )
  .fail((err) ->
    errorMsg = "failed to join competition. reason: #{err}"
    res.json(500, {error: errorMsg})
    console.error("[HTTP] 500: #{errorMsg}")
    console.error(err.stack)
  )
  .done()

withdrawFromCompetition = (req, res) ->

module.exports = {init}
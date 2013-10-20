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
  name = req.body.name

  @api.createUser(name)
  .then((user) ->
    res.json(201, user)
    console.log("[HTTP] 201: created user: #{user}")
  )
  .fail((err) =>
    @handleApiError(
      res,
      err,
      errorMsg: "failed to create user (name=#{name})"
    )
  )
  .done()

listCompetition = (req, res) ->
  if req.query.showClosed == 'true'
    showClosed = true

  competitionId = req.params.competitionId
  if not competitionId
    res.json(400, {message: "must provide competitionId"})
    return

  console.log "[HTTP] request to list competition (competitionId=#{competitionId}, showClosed=#{showClosed})"
  @listSingle(
    res,
    @api.listCompetitions(competitionId, showClosed),
    { typeName: 'competition', query: { competition_id: competitionId } }
  )

listCompetitions = (req, res) ->
  if req.query.showClosed == 'true'
    showClosed = true
  console.log "[HTTP] request to list competitions (showClosed=#{showClosed})"
  @listMultiple(
    res,
    @api.listCompetitions(null, showClosed),
    { typeName: 'competitions' }
  )

listCompetitionsByOwner = (req, res) ->
  @listMultiple(
    res,
    @api.listCompetitionsByOwner(req.params.ownerId),
    { typeName: 'competitions' }
  )

listCompetitionsByMembership = (req, res) ->
  if req.query.showClosed == 'true'
    showClosed = true

  @listMultiple(
    res,
    @api.listCompetitionsByMembership(req.params.userId, showClosed),
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
  ownerId = req.body.ownerId
  name = req.body.name

  @api.startCompetition(ownerId, name)
  .then((competition) ->
    res.json(201, competition)
    console.log("[HTTP] 201: started competition: #{competition}")
  )
  .fail((err) =>
    @handleApiError(res, err, errorMsg: "failed to start competition (ownerId=#{ownerId}, name=#{name})")
  )
  .done()

endCompetition = (req, res) ->
  competitionId = req.params.competitionId

  if not competitionId?
    res.json(400, {error: "must provide competitionId"})
    return

  @api.endCompetition(competitionId)
  .then((competition) ->
    res.json(200, competition)
    console.log "[HTTP] 200: ended competition: #{competition}"
  )
  .fail((err) =>
    @handleApiError(res, err, errorMsg: "failed to end competition (competitionId=#{competitionId})")
  )
  .done()

joinCompetition = (req, res) ->
  userId = req.body.userId
  competitionId = req.params.competitionId

  if not userId? and competitionId?
    res.json(400, {error: "must provide userId and competitionId"})
    return

  @api.joinCompetition(userId, competitionId)
  .then((competitionMembership) ->
    res.json(201, competitionMembership)
    console.log("[HTTP] 201: joined competition: #{competitionMembership}")
  )
  .fail((err) =>
    @handleApiError(res, err,
      errorMsg: "failed to join competition (userId=#{userId}, competitionId=#{competitionId})"
    )
  )
  .done()

withdrawFromCompetition = (req, res) ->
  userId = req.body.userId
  competitionId = req.params.competitionId

  if not userId? and competitionId?
    res.json(400, {error: "must provide userId and competitionId"})
    return

  @api.withdrawFromCompetition(userId, competitionId)
  .then((props) ->
    res.json(200, props)
    console.log "[HTTP] 200: withdrew from competition (userId=#{props.userId}, competitionId=#{props.competitionId})"
  )
  .fail((err) =>
    @handleApiError(res, err,
      errorMsg: "failed to withdraw from competition (userId=#{userId}, competitionId=#{competitionId})"
    )
  )

module.exports = {init}
Q = require 'q'
pie = require './lib/pie'

# API endpoints setup
init = (api, port) ->
  votingApi = new VotingHttpApi(port)
  votingApi.init(api)

class VotingHttpApi extends pie.HttpApi
  endpoints: -> [
    [/user\/\w+/, 'get', listUser]
    ['/users', 'get', listUsers]
    ['/user', 'post', createUser]
    ['/competitions/all', 'get', listCompetitions]
    ['/competitions/by-owner', 'get', listCompetitionsByOwner]
    ['/competitions/by-membership', 'get', listCompetitionsByMembership]
    ['/competition', 'post', startCompetition]
    ['/competition/end', 'post', endCompetition]
    # [/competition\/\w+/withdraw/, 'post', withdrawFromCompetition]
    # [/competition\/\w+/join/, 'post', joinCompetition]
    # [/competition\/\w+/, 'get', listCompetition]
  ]

# Endpoint handler methods

# Lists one user
listUser = (req, res) ->
  userId = @parseObjectId(req, 'user')
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
  competitionId = @parseObjectId(req, 'competitions/all')
  if not competitionId
    res.json(400, {message: "must provide competitionId"})
    return

  @listSingle(
    res,
    @api.listCompetitions(userId),
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

joinCompetition = (req, res) ->

withdrawFromCompetition = (req, res) ->

module.exports = {init}
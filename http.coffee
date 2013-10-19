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
    # [/competition\/\w+/withdraw/, 'post', withdrawFromCompetition]
    # [/competition\/\w+/join/, 'post', joinCompetition]
    # [/competition\/\w+/, 'get', listCompetition]
  ]

# Endpoint handler methods

# Lists one user
listUser = (req, res) ->
  userId = req.url.replace('/user/', '')
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

listCompetitions = (req, res) ->
  @api.listCompetitions()
  .then((competitions) =>
    if competitions?.length
      console.log "[HTTP] 200: found #{competitions.length} competitions"
      res.json(200, @createDataPage(competitions))
    else
      console.log "[HTTP] 404: no competitions found"
      res.json(404, {})
  )
  .fail((err) ->
    errorMsg = "failed to list competitions"
    res.json(500, {error: "#{errorMsg}. reason: #{err}"})
    console.error("[HTTP] 500: #{errorMsg}")
    console.error(err.stack)
  )
  .done()

listCompetitionsByOwner = (req, res) ->

listCompetitionsByMembership = (req, res) ->

joinCompetition = (req, res) ->

withdrawFromCompetition = (req, res) ->

module.exports = {init}
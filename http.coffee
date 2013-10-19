Q = require 'q'

# API endpoints setup
init = (api, port) ->
  express = require 'express'
  app = express()

  app.use(express.logger())
  app.use(express.compress())
  app.use(express.json())
  app.use(express.urlencoded())
  app.use(express.methodOverride())
  app.use(app.router)

  for [route, method, handler] in endpoints()
    console.log "[HTTP] adding endpoint: #{method} #{route}"
    app[method](route, handler(api))

  app.listen(port)
  console.log "[HTTP] listening on port #{port}"

# Enumeration of all endpoints
endpoints = -> [
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

# Creates an object suitable for use with paged UIs
createDataPage = (dataArray, offset = 0, limit = -1) ->
  return {
    totalCount: dataArray.length
    count: dataArray.length
    offset: offset
    limit: limit
    objects: dataArray
  }

# Endpoint handler methods

# Lists one user
listUser = (api) ->
  (req, res) ->
    userId = parseInt(req.url.replace('/user/', ''), 10)
    if not userId
      res.json(400, {message: "must provide userId"})
      return

    api.listUsers(userId)
    .then((user) ->
      if not user?.length
        console.log "[HTTP] 404: no user found for userId: #{userId}"
        res.json(404, {})
      else
        console.log "[HTTP] 200: found user: #{user[0]}"
        res.json(200, user[0])
    )
    .fail((err) ->
      errorMsg = "failed to find user. reason: #{err}"
      console.error(errorMsg)
      console.error(err.stack)
      res.json(500, {error: errorMsg})
    )
    .done()

# Lists all users
listUsers = (api) ->
  (req, res) ->
    api.listUsers()
    .then((users) ->
      if users?.length
        console.log "[HTTP] 200: found #{users.length} users"
        res.json(200, createDataPage(users))
      else
        console.log "[HTTP] 404: no users found"
        res.json(404, {})
    )
    .fail((err) ->
      errorMsg = 'failed to list users'
      res.json(500, {error: "#{errorMsg}. reason: #{err}"})
      console.error("[HTTP] 500: #{errorMsg}")
      console.error(err.stack)
    )
    .done()

createUser = (api) ->
  (req, res) ->
    api.createUser(req.body.name)
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

listCompetition = (api) ->
  (req, res) ->

listCompetitions = (api) ->
  (req, res) ->
    api.listCompetitions()
    .then((competitions) ->
      if competitions?.length
        console.log "[HTTP] 200: found #{competitions.length} competitions"
        res.json(200, createDataPage(competitions))
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

listCompetitionsByOwner = (api) ->
  (req, res) ->

listCompetitionsByMembership = (api) ->
  (req, res) ->

joinCompetition = (api) ->
  (req, res) ->

withdrawFromCompetition = (api) ->
  (req, res) ->

module.exports = {init}
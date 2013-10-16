Q = require 'q'

# API endpoints setup
init = (app, api) ->
  for [route, method, handler] in endpoints()
    console.log "adding endpoint: #{method} #{route}"
    app[method](route, handler(api))

# Enumeration of all endpoints
endpoints = -> [
  [/user\/\w+/, 'get', listUser]
  ['/users', 'get', listUsers]
  ['/user', 'post', createUser]
]

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
        console.log "404: no user found for userId: #{userId}"
        res.json(404, {})
      else
        console.log "200: found user: #{user[0]}"
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
        console.log "200: found users: ", users
        page =
          totalCount: users.length
          count: users.length
          offset: 0
          limit: -1
          objects: users

        res.json(200, page)
      else
        console.log "404: no users found"
        res.json(404, {})
    )
    .fail((err) ->
      res.json(500, {error: "failed to list users. reason: #{err}"})
      console.error("500: failed to list users")
      console.error(err.stack)
    )
    .done()

createUser = (api) ->
  (req, res) ->
    api.createUser(req.body.name)
    .then((user) ->
      respBody = "created user: #{user}"
      res.json(201, user)
      console.log("201: #{respBody}")
    )
    .fail((err) ->
      errorMsg = "failed to create user. reason: #{err}"
      res.json(500, {error: errorMsg})
      console.error(errorMsg)
      console.error(err.stack)
    )
    .done()

module.exports = {init}
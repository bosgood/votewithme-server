Q = require 'q'

# API endpoints setup
init = (app, api) ->
  for [route, method, handler] in endpoints()
    console.log "adding endpoint: #{route}"
    app[method](route, handler(api))

# Enumeration of all endpoints
endpoints = -> [
  [/user\/\w+/, 'get', listUser]
  ['/user', 'get', listUsers]
  ['/user', 'post', createUser]
]

# Endpoint handler methods

# Lists one user
listUser = (api) ->
  (req, res) ->
    userId =
    console.log 'list user'

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
        console.log "404: didn't find any users"
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
      res.json(500, {error: "couldn't create user. reason: #{err}"})
      console.error("500: couldn't create user")
      console.error(err.stack)
    )
    .done()

module.exports = {init}
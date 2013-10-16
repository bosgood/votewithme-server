Q = require 'q'

init = (app, api) ->
  for [route, method, handler] in endpoints()
    console.log "adding endpoint: #{route}"
    app[method](route, handler(api))

endpoints = -> [
  [/user\/\w+/, 'get', listUser]
  ['/user', 'get', listUsers]
  [/user/, 'post', createUser]
]

listUser = (api) ->
  (req, res) ->
    console.log 'list user'

listUsers = (api) ->
  (req, res) ->
    api.listUsers()
    .then((users) ->
      if users?.length
        console.log "200: found users: ", users
        res.json(200, users)
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
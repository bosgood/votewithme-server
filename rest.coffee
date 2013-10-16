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
    console.log 'list users'

createUser = (api) ->
  (req, res) ->
    console.log 'create user'
    api.createUser(req.body.name)
    .then((user) ->
      respBody = "created user: #{user}"
      res.send(201, respBody)
      console.log("201: #{respBody}")
    )
    .fail((err) ->
      res.send(500, "couldn't create user. reason: #{err}")
      console.error(err.stack)
    )
    .done()

module.exports = {init}
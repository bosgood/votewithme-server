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
    debugger
    console.log 'create user'
    api.createUser(req.body.name)
    .then((user) ->
      res.send(201, "created user: #{user}")
    )
    .fail((err) ->
      res.send(500, "couldn't create user. reason: #{err}")
    )
    .done()

module.exports = {init}
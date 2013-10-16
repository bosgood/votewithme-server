Q = require 'q'

# Provides a set of methods for voting data CRUD operations
class API
  constructor: (@db) ->
    throw "must provide db connection" unless @db

  createUser: (name) ->
    Q.nfcall(
      @db.models.User.create,
      name: name
    )

  incrementVote: ->

  decrementVote: (voteId) ->

  listUsers: (userId) ->

module.exports = API
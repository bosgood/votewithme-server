# Provides a set of methods for voting data CRUD operations
class API
  constructor: (@db) ->
    throw "must provide db connection" unless @db

  createUser: ->

  incrementVote: ->

  decrementVote: (voteId) ->

module.exports = API
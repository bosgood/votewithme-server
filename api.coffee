class API
  constructor: (@db) ->
    throw "must provide db connection" unless @db

  createUser: ->

  incrementVote: ->

  decrementVote: (voteId) ->

module.exports = API
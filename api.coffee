Q = require 'q'

# Provides a set of methods for voting data CRUD operations
class API
  constructor: (@db) ->
    throw "must provide db connection" unless @db

  createUser: (name) ->
    # Q.nfcall(
    #   @db.models.User.create,
    #   name: name
    # )

    # @db.models.User.create({
      # name: name
    # }, (err, user) ->

    deferred = Q.defer()
    user = new @db.models.User({name: name})
    user.save (err) ->
      if err
        deferred.reject(new Error(err))
      else
        deferred.resolve(user)

    deferred.promise

  incrementVote: ->

  decrementVote: (voteId) ->

  listUsers: (userId) ->

module.exports = API
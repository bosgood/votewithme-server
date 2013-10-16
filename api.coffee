Q = require 'q'
mongoose = require 'mongoose'
mongo = mongoose.mongo
ObjectID = mongo.ObjectID

# Provides a set of methods for voting data CRUD operations
class API
  constructor: (@db) ->
    throw "must provide db connection" unless @db
    @models = @db.models

  createUser: (name) ->
    create = Q.nbind(
      @models.User.create,
      @models.User
    )
    create name: name

  incrementVote: ->

  decrementVote: (voteId) ->

  listUsers: (userId) ->
    if userId?
      id = ObjectID(userId)
    find = Q.nbind(
      @models.User.find
      @models.User
    )
    find(_id: id)

module.exports = API
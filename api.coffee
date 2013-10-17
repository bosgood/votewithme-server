Q = require 'q'
mongoose = require 'mongoose'
mongo = mongoose.mongo
ObjectID = mongo.ObjectID
bus = require './bus'

models = require('./db').models
User = models.User
Competition = models.Competition
Vote = models.Vote
CompetitionMembership = models.CompetitionMembership
CompetitionCandidate = models.CompetitionCandidate

# Provides a set of methods for voting data CRUD operations
class API
  constructor: (@db) ->
    throw "must provide db connection" unless @db

  createUser: (name) ->
    create = Q.nbind(User.create, User)
    create(name: name)
    .then (val) ->
      bus.emit('user:created', val)
      val

  listUsers: (userId) ->
    if userId?
      query = _id: ObjectID(userId)

    find = Q.nbind(@User.find, @User)
    find(query)

  startCompetition: (userId, name) ->
    create = Q.nbind(@Competition.create, @Competition)
    create
      name: name
      owner_id: userId
      open: true
      type: 'multi'

  endCompetition: (competitionId) ->
    update = Q.nbind(@Competition.update, @Competition)
    update(
      { _id: competitionId },
      { open: false }
    )

  voteFor: (userId, competitionId, choiceId) ->
    update = Q.nbind(@Competition.update, @Competition)

  removeVoteFor: (userId, competitionId, choiceId) ->


module.exports = API
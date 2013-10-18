Q = require 'q'
mongoose = require 'mongoose'
mongo = mongoose.mongo
ObjectID = mongo.ObjectID
bus = require './bus'

models = require('./db').models
User = models.user
Competition = models.competition
Vote = models.vote
CompetitionMembership = models.competitionMembership
CompetitionCandidate = models.competitionCandidate

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
    find = Q.nbind(User.find, User)
    find(query)

  listCompetitionsOfOwner: (ownerId) ->
    if not userId?
      errPromise = Q.defer()
      errPromise.reject(
        new Error("must provide ownerId to list competitions")
      )
      return errPromise

    query = owner_id: ObjectID(userId)
    find = Q.nbind(Competition.find, Competition)
    find(query)

  listCompetitions: ->
    Q.nbind(Competition.find, Competition)()

  listCompetitionsByMembership: (userId) ->

  startCompetition: (userId, name) ->
    create = Q.nbind(Competition.create, Competition)
    create(
      name: name
      owner_id: userId
      open: true
      type: 'multi'
      participants: [ObjectID(userId)]
    ).then (competition) ->
      bus.emit('competition:started', competition)
      competition

  endCompetition: (competitionId) ->
    update = Q.nbind(Competition.findOneAndUpdate, Competition)
    update(
      { _id: competitionId },
      { open: false }
    ).then (competition) ->
      bus.emit('competition:ended', competition)
      competition

  voteFor: (userId, competitionId, choiceId) ->
    update = Q.nbind(@Vote.findByIdAndUpdate, @Vote)
    query =
      user_id: userId
    toUpdate =
      choice_id: choiceId

    update(query, toUpdate)
    .then (vote) ->
      bus.emit('vote:cast', vote)
      vote

  withdrawVoteFor: (userId, competitionId, choiceId) ->

  # changeVote: (userId, competitionId, choiceId) ->

module.exports = API
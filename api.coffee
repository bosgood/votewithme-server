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
class InternalApi
  constructor: (@db) ->
    throw "must provide db connection" unless @db

  createUser: (name) ->
    console.log "[API] create user (name=#{name})"
    Q.nbind(User.create, User)(name: name)
    .then (val) ->
      bus.emit('user:created', val)
      val

  listUsers: (userId) ->
    # TODO: set .lean() on query for performance
    console.log "[API] list users (userId=#{userId})"
    if userId?
      query = _id: ObjectID(userId)
    Q(User.find(query).exec())

  listCompetitionsByOwner: (ownerId) ->
    console.log "[API] list competitions by owner (ownerId=#{ownerId})"
    if not userId?
      errPromise = Q.defer()
      errPromise.reject(
        new Error("must provide ownerId to list competitions")
      )
      return errPromise

    query = owner_id: ObjectID(userId)
    Q(Competition.find(query).exec())

  listCompetitions: (competitionId) ->
    console.log "[API] list competitions (competitionId=#{competitionId})"
    if competitionId?
      query = _id: ObjectID(competitionId)
    Q(Competition.find(query).exec())

  listCompetitionsByMembership: (userId) ->
    console.log "[API] list competitions by membership (userId=#{userId})"
    Q(
      CompetitionMembership.find(
        user_id: userId
      )
      .exec()
    )
    .then((memberships) ->
      membershipIds = memberships.map((membership) ->
        _id: membership.competition_id
      )
      anyCompetition = { $or: membershipIds }
      Q(Competition.find(anyCompetition).exec())
    )

  listCompetitionMemberships: ->
    console.log "[API] list competition memberships"
    Q(CompetitionMembership.find().exec())

  joinCompetition: (userId, competitionId) ->
    console.log "[API] join competition (userId=#{userId}, competitionId=#{competitionId})"
    props =
      user_id: userId
      competition_id: competitionId

    # "Upsert" membership document
    Q(
      CompetitionMembership.findOneAndUpdate(
        props,
        props,
        { upsert: true }
      ).exec()
    ).then (competitionMembership) ->
      bus.emit('competitionMembership:withdrawn', competitionMembership)
      competitionMembership

  withdrawFromCompetition: (userId, competitionId) ->
    console.log "[API] withdraw from competition (userId=#{userId}, competitionId=#{competitionId})"
    props =
      user_id: userId
      competition_id: competitionId
    Q(
      CompetitionMembership.remove(props).exec()
    ).then ->
      bus.emit('competitionMembership:created', props)
      props

  startCompetition: (userId, name) ->
    console.log "[API] start competition (userId=#{userId}, name=#{name})"
    Q.nbind(Competition.create, Competition)(
        name: name
        owner_id: ObjectID(userId)
        open: true
        type: 'multi'
    )
    .then (competition) ->
      bus.emit('competition:started', competition)
      competition

  endCompetition: (competitionId) ->
    console.log "[API] end competition (competitionId=#{competitionId})"
    Q(
      # TODO is this working?
      Competition.findOneAndUpdate(
        { _id: ObjectID(competitionId) },
        { open: false }
      )
    ).then (competition) ->
      bus.emit('competition:ended', competition)
      competition

  voteFor: (userId, competitionId, choiceId) ->
    console.log "[API] vote for (userId=#{userId}, competitionId=#{competitionId}, choiceId=#{choiceId})"
    query =
      user_id: userId
    toUpdate =
      choice_id: choiceId

    # Only allows one vote per userId/competitionId pair
    Q(
      Vote.findOneAndUpdate(
        query,
        toUpdate,
        { upsert: true }
      ).exec()
    )
    .then (vote) ->
      bus.emit('vote:cast', vote)
      vote

  withdrawVoteFor: (userId, competitionId, choiceId) ->
    console.log "[API] withdraw vote for (userId=#{userId}, competitionId=#{competitionId}, choiceId=#{choiceId})"
    props =
      user_id: userId
    Q(
      Vote.remove(props).exec()
    ).then ->
      bus.emit('vote:withdrawn', props)
      props

module.exports = InternalApi
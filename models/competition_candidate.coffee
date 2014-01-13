# Represents an option that a user could vote for
mongoose = require 'mongoose'
ItemSchema = require './schema'
mongo = mongoose.mongo
ObjectId = mongoose.Schema.Types.ObjectId

competitionCandidateSchema = new ItemSchema
  user_id: ObjectId
  competition_id: ObjectId
  choice_id: ObjectId

CompetitionCandidate = mongoose.model('CompetitionCandidate', competitionCandidateSchema)
module.exports = CompetitionCandidate
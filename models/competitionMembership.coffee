# Represents the inclusion of a user in a competition
mongoose = require 'mongoose'
Schema = mongoose.Schema
mongo = mongoose.mongo
ObjectId = mongoose.Schema.Types.ObjectId

competitionMembershipSchema = new Schema
  user_id: ObjectId
  competition_id: ObjectId

CompetitionMembership = mongoose.model('CompetitionMembership', competitionMembershipSchema)
module.exports = CompetitionMembership
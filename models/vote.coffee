# Represents an option that a user voted for
mongoose = require 'mongoose'
Schema = mongoose.Schema
mongo = mongoose.mongo
ObjectId = mongoose.Schema.Types.ObjectId

voteSchema = new Schema
  user_id: ObjectId
  competition_id: ObjectId
  choice_id: ObjectId

Vote = mongoose.model('Vote', voteSchema)
module.exports = Vote
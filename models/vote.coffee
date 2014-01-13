# Represents an option that a user voted for
mongoose = require 'mongoose'
ItemSchema = require './schema'
mongo = mongoose.mongo
ObjectId = mongoose.Schema.Types.ObjectId

voteSchema = new ItemSchema
  user_id: ObjectId
  competition_id: ObjectId
  choice_id: ObjectId
  quantity: Number

Vote = mongoose.model('Vote', voteSchema)
module.exports = Vote
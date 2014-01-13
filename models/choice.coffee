# Represents an option that a user could vote for
mongoose = require 'mongoose'
ItemSchema = require './schema'
mongo = mongoose.mongo
ObjectId = mongoose.Schema.Types.ObjectId

choiceSchema = new ItemSchema
  competition_id: ObjectId
  name: String

Choice = mongoose.model('Choice', choiceSchema)
module.exports = Choice
# Represents an option that a user could vote for
mongoose = require 'mongoose'
Schema = mongoose.Schema
mongo = mongoose.mongo
ObjectId = mongoose.Schema.Types.ObjectId

choiceSchema = new Schema
  competition_id: ObjectId
  name: String

Choice = mongoose.model('Choice', choiceSchema)
module.exports = Choice
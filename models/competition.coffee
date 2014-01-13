# Represents a vote, ongoing or finished, between participants
mongoose = require 'mongoose'
ItemSchema = require './schema'
mongo = mongoose.mongo
ObjectId = mongoose.Schema.Types.ObjectId

competitionSchema = new ItemSchema
  name: String
  owner_id: ObjectId  # fk->db.users
  open: Boolean
  type: String  # multi|boolean

Competition = mongoose.model('Competition', competitionSchema)
module.exports = Competition


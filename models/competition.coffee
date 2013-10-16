mongoose = require 'mongoose'
mongo = mongoose.mongo

competitionSchema = new mongoose.Schema
  name: String
  owner_id: mongo.ObjectId  # fk->db.users
  open: Boolean
  type: String  # multi|boolean
  choices: [
    _id: String
    count: Number
  ]

  ###
  choices: [
    {
      _id: 'true'
      count: Number
    }
    {
      _id: 'false'
      count: Number
    }
  ]
  // for multi
  choices: [
    {
      _id: ObjectId
      count: Number
    }
    ...
  ]
  ###

Competition = mongoose.model('Competition', competitionSchema)
module.exports = Competition
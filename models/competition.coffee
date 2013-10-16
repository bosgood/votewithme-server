mongoose = require 'mongoose'

competitionSchema = new mongoose.Schema
  owner_id: ObjectId  # fk->db.users
  name: String
  open: Boolean
  type: String  # multi|boolean
  choices: [{
    _id: String
    count: number
  }]
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
mongoose = require 'mongoose'
Schema = mongoose.Schema
mongo = mongoose.mongo
ObjectId = mongoose.Schema.Types.ObjectId

competitionSchema = new Schema
  name: String
  owner_id: ObjectId  # fk->db.users
  open: Boolean
  type: String  # multi|boolean
  choices: [
    count: Number
  ]

  # choices: [
  #   {
  #     _id: 'true'
  #     count: Number
  #   }
  #   {
  #     _id: 'false'
  #     count: Number
  #   }
  # ]
  # // for multi
  # choices: [
  #   {
  #     _id: ObjectId
  #     count: Number
  #   }
  #   ...
  # ]

Competition = mongoose.model('Competition', competitionSchema)
module.exports = Competition


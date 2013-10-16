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
    choice_id: ObjectId
    count: Number
    name: String
  ]

Competition = mongoose.model('Competition', competitionSchema)
module.exports = Competition


mongoose = require 'mongoose'
ItemSchema = require './schema'
mongo = mongoose.mongo
ObjectID = mongo.ObjectID

userSchema = new ItemSchema
  name: String

User = mongoose.model('User', userSchema)
module.exports = User
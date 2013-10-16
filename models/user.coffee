mongoose = require 'mongoose'
Schema = mongoose.Schema
mongo = mongoose.mongo
ObjectID = mongo.ObjectID

userSchema = new Schema
  name: String

User = mongoose.model('User', userSchema)
module.exports = User
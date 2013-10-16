mongoose = require 'mongoose'

userSchema = new mongoose.Schema
  name: String

User = mongoose.model('User', userSchema)
module.exports = User
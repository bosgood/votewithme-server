mongoose = require 'mongoose'

userSchema = new mongoose.Schema
  name: String

User = mongoose.model('Competition', userSchema)
module.exports = User
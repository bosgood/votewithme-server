mongoose = require 'mongoose'
fs = require 'fs'

# DB Models
models = {}
models.User = require './models/user'
# models.Competition = require './models/competition'

# Gets a connection to MongoLab or a local MongoDB instance
connect = ->
  CURRENT_ENV = process.env.ENV or 'local'
  envContext = JSON.parse(fs.readFileSync("./.environment/#{CURRENT_ENV}"))
  mongo = mongoose.connect(
    "#{envContext.user}:#{envContext.password}@#{envContext.url}",
    {
      journal: true
      # database: envContext.database or 'voting'
    }
  )
  mongo

module.exports = {connect, models}
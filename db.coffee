mongoose = require 'mongoose'
fs = require 'fs'

# DB Models
models = require './models'

# Gets a connection to MongoLab or a local MongoDB instance
connect = ->
  CURRENT_ENV = process.env.ENV or 'local'
  envContext = JSON.parse(fs.readFileSync("./.environment/#{CURRENT_ENV}"))

  console.log "[DB] ENVIRONMENT: #{CURRENT_ENV}"
  console.log "[DB] connecting as user: #{envContext.user}"
  console.log "[DB] database URL: #{envContext.url}"
  db = mongoose.connect(
    "#{envContext.user}:#{envContext.password}@#{envContext.url}",
    {
      journal: true
      # database: envContext.database or 'voting'
    }
  )
  db.connection.on('connected', handleDbConnected)
  db.connection.on('disconnected', handleDbDisconnected)
  db

handleDbConnected = ->
  console.log("[DB] database connected")

handleDbDisconnected = ->
  console.log("[DB] database disconnected")
  # TODO: worry about using keepAlive and how to reconnect on error

module.exports = {connect, models}
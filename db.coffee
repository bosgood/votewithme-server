mongoose = require 'mongoose'
fs = require 'fs'

# DB Models
models = require './models'

getContext = ->
  env = process.env
  CURRENT_ENV = env.ENV or 'local'
  if process.env.LIVE
    ctx =
      env: CURRENT_ENV
      db:
        url: env.DB_URL
        user: env.DB_USER
        password: env.DB_PASSWORD
  else
    ctx = JSON.parse(fs.readFileSync("./.environment/#{CURRENT_ENV}"))
    ctx.env = CURRENT_ENV
  ctx

# Gets a connection to MongoLab or a local MongoDB instance
connect = ->
  ctx = getContext()
  console.log "[DB] ENVIRONMENT: #{ctx.env}"
  console.log "[DB] connecting as user: #{ctx.db.user}"
  console.log "[DB] database URL: #{ctx.db.url}"
  db = mongoose.connect(
    "#{ctx.db.user}:#{ctx.db.password}@#{ctx.db.url}",
    {
      journal: true
      # database: ctx.database or 'voting'
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
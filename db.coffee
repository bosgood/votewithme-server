mongoskin = require 'mongoskin'
fs = require 'fs'

# Gets a connection to MongoLab or a local MongoDB instance
connect = ->
  CURRENT_ENV = process.env.ENV or 'local'
  envContext = JSON.parse(fs.readFileSync("./.environment/#{CURRENT_ENV}"))
  mongo = mongoskin.db(
    "#{envContext.user}:#{envContext.password}@#{envContext.url}",
    {
      journal: true
      # database: envContext.database or 'voting'
    }
  )
  mongo

module.exports = {connect}

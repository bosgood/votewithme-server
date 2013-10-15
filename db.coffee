mongoskin = require 'mongoskin'

connect = ->
  CURRENT_ENV = process.env.ENV or 'local'
  envContext = JSON.parse(fs.readFileSync("./env/#{CURRENT_ENV}"))
  mongo = mongoskin.db("mongodb://#{envContext.user}:#{envContext.password}@#{envContext.url}")
  mongo

module.exports = connect
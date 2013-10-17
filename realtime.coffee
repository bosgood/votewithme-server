io = require 'socket.io'
bus = require './bus'

init = ->
  for [eventName, handler] in events()
    bus.on(eventName, handler)
    console.log "[REALTIME] listening for: #{eventName}"

events = -> [
  ['user:created', userCreated]
  ['user:deleted', userDeleted]
  ['competition:started', competitionStarted]
  ['competition:ended', competitionEnded]
]

userCreated = (user) ->
  console.log "[REALTIME] user created"

userDeleted = (user) ->
  console.log "[REALTIME] user deleted"

competitionStarted = (competition) ->
  console.log "[REALTIME] competition started"

competitionEnded = (competition) ->
  console.log "[REALTIME] competition ended"

module.exports = {init}
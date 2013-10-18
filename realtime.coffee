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
  ['vote:cast', voteCast]
  ['vote:withdrawn', voteWithdrawn]
  ['competitionMembership:created', competitionMembershipCreated]
  ['competitionMembership:withdrawn', competitionMembershipWithdrawn]
]

userCreated = (user) ->
  console.log "[REALTIME] user created (userId=#{user._id})"

userDeleted = (user) ->
  console.log "[REALTIME] user deleted (userId=#{user._id})"

competitionStarted = (competition) ->
  console.log "[REALTIME] competition started (competitionId=#{competition._id})"

competitionEnded = (competition) ->
  console.log "[REALTIME] competition ended (competitionId=#{competition._id})"

voteCast = (vote) ->
  console.log "[REALTIME] vote cast (userId=#{vote.user_id}, choiceId=#{vote.choice_id})"

voteWithdrawn = (vote) ->
  console.log "[REALTIME] vote withdrawn (userId=#{vote.user_id}, choiceId=#{vote.choice_id})"

competitionMembershipCreated = (competitionMembership) ->
  console.log "[REALTIME] competition joined (userId=#{competitionMembership.user_id}, competitionId=#{competitionMembership.competition_id})"

competitionMembershipWithdrawn = (competitionMembership) ->
  console.log "[REALTIME] competition left (userId=#{competitionMembership.user_id}, competitionId=#{competitionMembership.competition_id})"

module.exports = {init}
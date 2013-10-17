events = require 'events'

class EventBus extends events.EventEmitter

module.exports = new EventBus
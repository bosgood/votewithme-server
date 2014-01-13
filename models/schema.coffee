mongoose = require 'mongoose'
Schema = mongoose.Schema

class ItemSchema extends Schema
  constructor: ->
    super
    @pre 'save', (next) ->
      now = new Date
      @updated_at = now
      @created_at ?= now
      next()

  created_at: type: Date
  updated_at: type: Date

module.exports = ItemSchema
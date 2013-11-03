{models, Resource, filters} = require '../resource_helper'

MembershipResource = new Resource
  resourceName: 'memberships'
  model: models.competition_membership

module.exports = MembershipResource
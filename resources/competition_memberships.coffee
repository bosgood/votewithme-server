{models, Resource, filters} = require '../resource_helper'

MembershipResource = new Resource
  resourceNameMany: 'memberships'
  resourceNameOne: 'membership'
  model: models.competition_membership

module.exports = MembershipResource
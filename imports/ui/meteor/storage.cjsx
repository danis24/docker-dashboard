{ Meteor }          = require 'meteor/meteor'
{ createContainer } = require 'meteor/react-meteor-data'
React               = require 'react'
Helpers             = require '../../helpers.coffee'
Storage             = require '../storage.cjsx'


module.exports = createContainer (props) ->

  buckets: StorageBuckets?.find({name: {$regex: props.filter or '', $options: 'i'}}, sort: name: 1).fetch()
  onDelete: -> Meteor.call 'storage/buckets/delete', @_id
  authenticated: Helpers.isAuthenticated()
, Storage
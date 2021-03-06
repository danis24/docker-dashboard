Meteor.startup ->
  if Meteor.isServer

    lib = require './lib.coffee'
    keys = require '/server/utils/deploykeys.coffee'

    authenticationHandler = ->
      if (key = @params.query?['api-key']) or (key = @request.headers?['api-key'])
        if (apiKey = APIKeys.findOne key: key)
          user = Meteor.users.findOne(apiKey.owner)
          if user
            @next()
          else
            lib.endWithError @response, 401, "Not authenticated" 
        else if(key in keys()) 
          user = "deploy"
          @next()
        else 
          lib.endWithError @response, 401, "Not authenticated"
      else lib.endWithError @response, 401, "No API key provided"

    Router.onBeforeAction authenticationHandler, only:
      [
        'api/v2/apps/details'
        'api/v2/apps/dockerCompose'
        'api/v2/apps/bigboatCompose'
        'api/v2/apps/byName'
        'api/v2/apps'
        'api/v2/instances'
        'api/v2/instances/single'
        'api/v2/storageBuckets'
        'api/v2/storageBuckets/single'
        'api/v2/storageBuckets/create'
        'api/v2/status'
      ]


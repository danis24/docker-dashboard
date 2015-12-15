Template.logs.helpers
  isLoading: -> Session.get("log#{@containerId or @instanceId}") is 'loading'
  hasLogLines: -> Session.get("log#{@containerId or @instanceId}").length > 0

Template.logs.onCreated ->
  Session.set "log#{@data.containerId}", 'loading'

Template.logs.onRendered ->
  $('body').height('100%')
  $('html').height('100%')
  if @data.containerId
    Meteor.call 'getLog', @data.containerId, (err, data) =>
      if err
        console.warn "Error while getting logs for #{@data.containerId}", err
      else Session.set "log#{@data.containerId}", data
  if @data.instanceId
    Meteor.call 'getInstanceLog', @data.instanceId, (err, data) =>
      if err
        console.warn "Error while getting logs for #{@data.instanceId}", err
      else Session.set "log#{@data.instanceId}", data

Template.logs.onDestroyed ->
  Session.set "log#{@containerId}", null

Template.logTable.helpers
  logLines: -> Session.get "log#{@containerId or @instanceId}"
  formattedLogLine: ->
    if match = @message.match /<\d{2}>(\d{4}-\d{2}-[\d]{2}T[\d]{2}:[\d]{2}:[\d]{2}Z).+docker\/\w{12}\[\d+\]: (.+)/
      [all, date, log] = match
      date: @date, log: log
    else if match = @message.match /\w+\s=> (.+)/
      [all, log] = match
      date: @date, log: log
    else @

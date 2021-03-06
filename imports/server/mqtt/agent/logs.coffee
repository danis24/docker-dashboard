reconciler  = require '../../stateReconciler.coffee'

module.exports =
  startup: (logEvent) ->
    reconciler.updateStartupLogs logEvent.instance, logEvent.data

  startupFailed: (logEvent) ->
    reconciler.updateStartupFailedLogs logEvent.instance, logEvent.data

  teardown: (logEvent) ->
    reconciler.updateTeardownLogs logEvent.instance, logEvent.data

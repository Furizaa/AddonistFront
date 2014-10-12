aoi = @.aoi

module = angular.module("aoiBindings", [])

class BindingsService extends aoi.Service
  @.$inject = ["$window", "$log"]

  constructor: (@window, @log) ->
    @log.error("Addonist Context not found!") if not @window.$$cBindings
    @binding = @window.$$cBindings
    super()

  bootstrap: ->
    @window.alert(@binding.bootstrap())


module.service("aoiBindings", BindingsService)
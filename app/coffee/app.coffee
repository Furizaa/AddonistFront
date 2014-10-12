###
# Copyright (C) 2014 Andreas Hoffmann <furizaa@gmail.com>
###

@aoi = aoi = {}

init = ($log, c) ->
  $log.info("Addoist Initialized")
  c.bootstrap()

module = angular.module("aoi", ["aoiBindings"])

module.run(["$log", "aoiBindings", init]);
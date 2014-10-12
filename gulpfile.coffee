gulp = require 'gulp'
less = require 'gulp-less'
rename = require 'gulp-rename'
concat = require 'gulp-concat'
uglify = require 'gulp-uglify'
coffee = require 'gulp-coffee'
jade = require 'gulp-jade'
npmMod = require "./package.json"

paths = {}
paths.app = "app/"
paths.bower = "bower_components/"
paths.tmp = "tmp/"
paths.dist = "dist/"

files = {}
files.less = paths.app + "styles/**/*.less"
files.coffee = [
  paths.app + "coffee/app.coffee",
  paths.app + "coffee/*.coffee",
  paths.app + "coffee/modules/*.coffee"
]
files.templates = [
  paths.app + 'index.jade',
  paths.app + 'templates/**/*.jade'
]
files.vendor = [
  paths.bower + "angular/angular.js"
]

## Styles

gulp.task "less-watch", ->
  gulp.src(paths.app + "styles/main.less")
      .pipe(less(paths: [ paths.bower + "bootstrap/less/" ]))
      .pipe(rename("addonist.css"))
      .pipe(gulp.dest(paths.dist + "styles/"));

## Js

gulp.task "jsvendor-watch", ->
  gulp.src(files.vendor)
      .pipe(concat("vendor.js"))
      .pipe(gulp.dest(paths.dist + "js/"))

gulp.task "app-watch", ->
  gulp.src(files.coffee)
      .pipe(coffee())
      .pipe(concat("addonist.js"))
      .pipe(gulp.dest(paths.dist + 'js/'))

## Templates

gulp.task "templates-watch", ->
  gulp.src(paths.app + "index.jade")
      .pipe(jade(pretty: true, locals:{ version: npmMod.version }))
      .pipe(gulp.dest(paths.dist))

## Express

gulp.task "express", ->
  express = require "express"
  app = express()

  app.use("/js", express.static("#{__dirname}/dist/js"))
  app.use("/styles", express.static("#{__dirname}/dist/styles"))
  app.all "/*", (req, res, next) ->
    res.sendFile("index.html", root: "#{__dirname}/dist/")

  app.listen(9001)


## Meta

gulp.task "watch", ->
  gulp.watch(files.less, ["less-watch"])
  gulp.watch(files.vendor, ["jsvendor-watch"])
  gulp.watch(files.coffee, ["app-watch"])
  gulp.watch(files.templates, ["templates-watch"])

gulp.task "default", [
  "less-watch",
  "jsvendor-watch",
  "app-watch",
  "templates-watch"
  "express",
  "watch"
]



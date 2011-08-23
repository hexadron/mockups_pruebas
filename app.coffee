express = require 'express'
asset = require './asset.coffee'

#cradle = require 'cradle'

app = module.exports = express.createServer()

#conn = new(cradle.Connection)()
#db = conn.database 'nombre_de_la_base_de_datos'

app.configure ->
  app.set 'views', "#{__dirname}/views"
  app.set 'view engine', 'jade'
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static "#{__dirname}/public"

asset.minify
  source: 'assets/scripts'
  lib_source: 'assets/scripts/libs'
  libs: ['modernizr-2.0.6.min','underscore', 'jquery-1.6.2.min', 'backbone']
  target: 'public/javascripts/core'

asset.sasscompile __dirname

app.configure 'development', ->
  app.use express.errorHandler
    dumpExceptions: true
    showStack: true

app.configure 'production', ->
  app.use express.errorHandler()

app.get '/', (req, res) ->
  res.render 'index',
    title: 'Mockups'

app.listen 3000
#éste es sólo un comentario mientras tanto
console.log "Express server listening on port %d", app.address().port

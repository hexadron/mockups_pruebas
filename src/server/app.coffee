express = require 'express'
app     = express.createServer()
casset  = require 'casset'
io      = require('socket.io').listen(app)
fs      = require 'fs'

app.configure ->
  app.set 'views', '../../public/views'
  app.set 'view engine', 'jade'
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static "../../public"

casset.apphome = '../..'
casset.sasscompile()
casset.minify
  source: 'assets/scripts'
  lib_source: 'assets/scripts/libs'
  libs: ['modernizr-2.0.6.min','underscore', 'jquery-1.6.2.min', 'backbone']
  target: 'public/javascripts/core'

app.configure 'development', ->
  app.use express.errorHandler
    dumpExceptions: true
    showStack: true

app.configure 'production', ->
  app.use express.errorHandler()

app.listen 3000

require('./route.coffee')(app)

# emisor de socket io
io.sockets.on 'connection', (socket) ->
  socket.emit 'news',
    text: 'world'
  socket.on 'my other event', (data) ->
    console.log "@@@@@@@@@@@@@@@@@@@@@@@@@@@#{i for i in [1..100]}"
    socket.emit 'news',
      hello: 'Otra vez!!'

console.log "Servidor ejecutándose en:\n http://localhost:%d", app.address().port

#io      = require('socket.io').listen app
#cradle  = require 'cradle'
#db      = new(cradle.Connection)().database 'mockups'
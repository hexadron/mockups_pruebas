express = require 'express'
casset = require 'casset'
fs = require 'fs'

#cradle = require 'cradle'

app = module.exports = express.createServer()

#cn = new(cradle.Connection)()
#db = cn.database 'nombre_de_la_base_de_datos'

app.configure ->
  app.set 'views', '../../public/views'
  app.set 'view engine', 'jade'
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static "../../public"

casset.apphome = '../..'

#casset.sasscompile() # comentado para disminuir los procesos de ruby

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

app.get '/', (req, res) ->
  res.render 'index',
    title: 'Mockups'

app.post '/', (req, res) ->
  if req.body.write == 'true'
    console.log "DEBE ESCRIBIR #{req.body.text}"
    fs.writeFile 'logs.txt', req.body.text, (err) ->
      console.log "ESCRIBE"
      if err? then console.log err
      check req, res
  else
    if req.body.wait == "true"
      check req, res
    else
      fs.readFile 'logs.txt', 'utf8', (err, data) ->
        res.write data
        res.end()

check = (req, res) ->
  checkchanges req, (hay, data)->
    if hay
      res.write data
      res.end()
    else
      setTimeout (-> check req, res), 750

checkchanges = (req, callback) ->
  fs.stat 'logs.txt', (err, stats) ->
    if stats.mtime.getTime() > req.socket._idleStart.getTime()
      fs.readFile 'logs.txt', 'utf8', (err, data) ->
        if callback? then callback true, data
    else
      if callback? then callback false

app.listen 3000

console.log "Servidor ejecutándose en:\n http://localhost:%d", app.address().port
express = require 'express'
stylus = require 'stylus'
#cradle = require 'cradle'

app = module.exports = express.createServer()

#conn = new(cradle.Connection)()
#db = conn.database 'nombre_de_la_base_de_datos'

compileMethod = (str) ->
  return stylus(str).set 'compress', true

app.configure ->
  app.set 'views', "#{__dirname}/views"
  app.set 'view engine', 'jade'
  app.use stylus.middleware
    debug: true
    src: "#{__dirname}/public"
    dest: "#{__dirname}/public"
    compile: compileMethod
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static "#{__dirname}/public"

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

express = require 'express'

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

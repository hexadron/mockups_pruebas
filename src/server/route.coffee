index = require '../controllers/index.coffee'

module.exports = (app) ->
  app.get  '/', index.index
  app.post '/', index.listen
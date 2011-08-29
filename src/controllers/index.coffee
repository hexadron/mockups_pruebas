fs = require 'fs'

exports.index = (req, res) ->
  res.render 'index',
    title: 'Mockups'

exports.listen = (req, res) ->
  if req.body.write == 'true'
    fs.writeFile 'logs.txt', req.body.text, (err) ->
      if err? then console.log err
      check req, res
  else
    if req.body.wait == "true"
      check req, res
    else
      fs.readFile 'logs.txt', 'utf8', (err, data) ->
        res.write data
        res.end()

# long polling
check = (req, res) ->
  fs.stat 'logs.txt', (err, stats) ->
    if stats.mtime.getTime() > req.socket._idleStart.getTime()
      fs.readFile 'logs.txt', 'utf8', (err, data) ->
        res.write data
        res.end()
    else
      setTimeout (-> check req, res), 750
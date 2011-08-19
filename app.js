(function() {
  var app, compileMethod, express, stylus;
  express = require('express');
  stylus = require('stylus');
  app = module.exports = express.createServer();
  compileMethod = function(str) {
    return stylus(str).set('compress', true);
  };
  app.configure(function() {
    app.set('views', "" + __dirname + "/views");
    app.set('view engine', 'jade');
    app.use(stylus.middleware({
      debug: true,
      src: "" + __dirname + "/public",
      dest: "" + __dirname + "/public",
      compile: compileMethod
    }));
    app.use(express.bodyParser());
    app.use(express.methodOverride());
    app.use(app.router);
    return app.use(express.static("" + __dirname + "/public"));
  });
  app.configure('development', function() {
    return app.use(express.errorHandler({
      dumpExceptions: true,
      showStack: true
    }));
  });
  app.configure('production', function() {
    return app.use(express.errorHandler());
  });
  app.get('/', function(req, res) {
    return res.render('index', {
      title: 'Mockups'
    });
  });
  app.listen(3000);
  console.log("Express server listening on port %d", app.address().port);
}).call(this);

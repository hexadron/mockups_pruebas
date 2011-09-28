(function() {
  window.log = function() {
    var newarr;
    log.history = log.history || [];
    log.history.push(arguments);
    if (this.console) {
      arguments.callee = arguments.callee.caller;
      newarr = [].slice.call(arguments);
      if (typeof console.log === "object") {
        return log.apply.call(console.log, console, newarr);
      } else {
        return console.log.apply(console, newarr);
      }
    }
  };
  (function(b) {
    var a, c, d, _results;
    c = function() {};
    d = "assert,count,debug,dir,dirxml,error,exception,group,groupCollapsed,groupEnd,info,log,timeStamp,profile,profileEnd,time,timeEnd,trace,warn".split(",");
    _results = [];
    while (a = d.pop()) {
      _results.push(b[a] = b[a] || c);
    }
    return _results;
  })((function() {
    try {
      console.log();
      return window.console;
    } catch (err) {
      return window.console = {};
    }
  })());
  String.prototype.startsWith = function(str) {
    return this.slice(0, str.length) === str;
  };
  String.prototype.contains = function(str) {
    return this.indexOf(str) !== -1;
  };
  String.prototype.endsWith = function(str) {
    return this.slice(-str.length) === str;
  };
  $.fn.reverse = [].reverse;
}).call(this);

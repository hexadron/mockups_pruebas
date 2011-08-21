## Paul Irish's wrapper for console.log, included in h5bp

window.log = ->
  log.history = log.history or []
  log.history.push arguments
  if @console
    arguments.callee = arguments.callee.caller
    newarr = [].slice.call(arguments)
    (if typeof console.log == "object" then log.apply.call(console.log, console, newarr) else console.log.apply(console, newarr))

((b) ->
  c = ->
  d = "assert,count,debug,dir,dirxml,error,exception,group,groupCollapsed,groupEnd,info,log,timeStamp,profile,profileEnd,time,timeEnd,trace,warn".split(",")
  
  while a = d.pop()
    b[a] = b[a] or c
) (->
  try
    console.log()
    return window.console
  catch err
    return window.console = {}
)()

## Prototypes

String::startsWith = (str) -> @slice(0, str.length) == str

String::contains = (str) -> @indexOf(str) != -1

String::endsWith = (str) -> @slice(-str.length) == str

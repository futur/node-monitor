#
# A test suite for lib/config.
#

Function::trace = do () =>
  makeTracing = (ctorName, fnName, fn) =>
    (args...) ->
      console.log "TRACE #{ctorName}:#{fnName}"
      fn.apply @, args
  (arg) ->
    for own name, fn of arg 
      @prototype[name] = makeTracing @name, name, fn

Config = require '../../lib/config'
config = new Config()

config.on 'log:info', (msg) ->
  console.log 'log:info! - ' + msg

config.on 'log:warn', (msg) ->
  console.log 'log:warn! - ' + msg

config.init (error) ->
  console.log error if error isnt false
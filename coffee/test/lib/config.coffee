Function::trace = do ->
  makeTracing = (ctorName, fnName, fn) ->
    (args...) ->
      console.log "#{ctorName}:#{fnName}"
      fn.apply @, args
  (arg) ->
    for own name, fn of arg 
      @prototype[name] = makeTracing @name, name, fn

config = require '../../lib/config'
config = new config.Config()

config.on 'log', (msg) ->
  console.log 'we listend! ' + msg

config.connect (error) ->
  console.log error if error isnt false

#config.get 'aws:key', (key) ->
  #console.log key
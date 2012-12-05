#!/usr/bin/env coffee

#
# The command-line input handler.
#

# Deps
program = require 'commander'

# Exceptions
process.on 'uncaughtException', (error) =>
  console.log 'Caught unhandled Node.js exception: ' + error      

# TRACE Logging
# TODO make optional
Function::trace = do () =>
  
  makeTracing = (ctorName, fnName, fn) =>
    (args...) ->
      console.log "TRACE #{ctorName}:#{fnName}"
      fn.apply @, args
  (arg) ->
    for own name, fn of arg 
      @prototype[name] = makeTracing @name, name, fn  

# V========= Excecution =========V #

program.on 'run', =>
  
  new NodeMonitor()
  process.stdin.destroy()

program.on 'debug', =>
  
  cmd.debug()
  process.stdin.destroy()
	
	
# V========= Configuration =========V #
	
program.on 'configure:interface:aws', =>
  
  program.prompt 'ASW: ', (key) =>
    console.log 'key: \'%s\'', key

    cmd.configure 'interface:aws', key, null, (error) =>
      process.stdin.destroy()

program.on 'configure:webservice', =>
  
  process.stdin.destroy()
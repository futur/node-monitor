{EventEmitter} = require 'events'

logInterface = new EventEmitter

logInterface.on 'log:info', (msg) -> 
  console.log msg
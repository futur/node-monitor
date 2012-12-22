{EventEmitter} = require 'events'

pluginInterface = new EventEmitter

pluginInterface.on 'plugin:cpu', (msg) -> 
  console.log msg

pluginInterface.on 'plugin:heroku', (msg) -> 
  console.log msg
ws = require 'websocket-server'

Plugin =
  name: 'websocket'
  command: ''
  type: 'lone'

@name = Plugin.name
@type = Plugin.type

@run = (utilities, callback) ->
  
  self = this
  self.utilities = utilities
    
  server = ws.createServer
  server.onmessage = (event) ->
    
    console.log 'Websocket connection opened'
  
  server.onmessage, (event) ->
    
    console.log event.data
    self.utilities.runCommand event.data.command, response ->
      
      message = 
        received: event.data
        cmd: response
      
      server.send JSON.stringify response

	server.listen 8080
  
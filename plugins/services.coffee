require 'net'

Plugin =
  name: 'services'
  command: ''
  type: 'poll'
  services: {}

@name = Plugin.name
@type = Plugin.type

@poll = (utilities, callback) ->
  
  self = this
  self.utilities = utilities
  
  self.utilities.parseFileAtNewlineAndEquals Plugin.name + '_config', (contents) ->
    
    # Service name, port (which is 0 if ignored)
    for key of contents
      Plugin.services[contents[key]] = Number contents[key]
    
    for service of Plugin.services
      if Plugin.services[service] is 0
        console.log 'Checking status service: ' + service
        Plugin.command = 'ps ax | grep -v grep | grep -v tail | grep ' + service
      else 
        console.log 'Checking status service: ' + service + ', on port: ' + Plugin.services[service]
        Plugin.command = 'lsof -i :' + Plugin.services[service]
      
        self.utilities.runCommand Plugin.command, (response) ->
      
          status = '0'
          if self.utilities.isEmpty(response)
            status = '0'
          else
            status = '1'
          
          callback Plugin.name, 'RunningProcess-' + service, 'None', status
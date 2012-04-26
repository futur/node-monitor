Plugin =
  name: 'api'
  command: ''
  type: 'poll'

@name = Plugin.name
@type = Plugin.type

@poll = (utilities, callback) ->
  
  self = this
  self.utilities = utilities
    
  self.utilities.runCommand Plugin.command, response ->
    
    callback Plugin.name, 'OpenFiles', 'Count', response
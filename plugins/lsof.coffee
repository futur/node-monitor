Plugin =
  name: 'lsof'
  command: ''
  type: 'poll'

@name = Plugin.name
@type = Plugin.type

@poll = (utilities, callback) ->
  
  self = this
  self.utilities = utilities
  
  switch self.utilities.getPlatform
    when 'darwin'
      Plugin.command = '?'
    when 'linux'
      Plugin.command = 'lsof | wc -l'
    else
      console.log 'Unaccounted for system: ' + self.utilities.getPlatform
      return
  
  self.utilities.runCommand Plugin.command, response ->
    
    callback Plugin.name, 'OpenFiles', 'Count', response
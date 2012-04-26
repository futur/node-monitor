Plugin =
  name: 'df'
  command: ''
  type: 'poll'

@name = Plugin.name
@type = Plugin.type

@poll = (utilities, callback) ->
  
  self = this
  self.utilities = utilities
  
  self.utilities.parseFileAtNewline Plugin.name + '_config', (contents) ->

    contents.forEach (disk) ->
      
      Plugin.command = 'df -h | grep -v grep | grep \'' + disk + '\' | awk \'{print $5}\'' unless self.utilities.isEmpty(disk)
      self.utilities.runCommand Plugin.command, (response) ->
      
        callback Plugin.name, 'DiskSpace', 'Percent', response.replace '%', ''

    
  
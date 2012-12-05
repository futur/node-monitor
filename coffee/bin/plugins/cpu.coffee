Plugin =
  name: 'cpu'
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
      Plugin.command = 'top -b -n 1 | awk \'NR==3{print$2}\''
    else
      console.log 'Unaccounted for system: ' + self.utilities.getPlatform
      return
  
  self.utilities.runCommand Plugin.command, response ->
    
    callback Plugin.name, 'CpuUsage', 'Percent', Math.round Number response
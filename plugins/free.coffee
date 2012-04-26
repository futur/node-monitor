Plugin =
  name: 'free'
  command: ''
  type: 'poll'

@name = Plugin.name
@type = Plugin.type

@poll = (utilities, callback) ->
  
  self = this
  self.utilities = utilities
    
  switch self.utilities.getPlatform
    when 'darwin'
      Plugin.command = 'top -l 1 | awk \'/PhysMem/ {print $10}\''
    when 'linux'
      Plugin.command = 'free -t -m | awk \'NR==5{print $4}\''
    else
      console.log 'Unaccounted for system: ' + self.utilities.getPlatform
      return
  
  self.utilities.runCommand Plugin.command, response ->
    
    callback Plugin.name, 'MemoryFree', 'Megabytes', response

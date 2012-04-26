Plugin =
  name: 'uptime'
  command: 'cat /proc/uptime | awk \'{print$1}\''
  type: 'poll'

@name = Plugin.name
@type = Plugin.type


@poll = (utilities, callback) ->
  
  self = this
  self.utilities = utilities
  
  self.utilities.runCommand Plugin.command, (response) ->
  
    callback Plugin.name, 'Uptime', 'Seconds', response.replace /^(\s*)((\S+\s*?)*)(\s*)$/, '$2'
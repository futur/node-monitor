Plugin =
  name: 'who'
  command: 'who'
  type: 'poll'

@name = Plugin.name
@type = Plugin.type

Plugin.format = (data) ->
  splitBuffer = []
  splitBuffer = data.split '\n'
  users = {}
  i = 0
  while i < splitBuffer.length
    line = splitBuffer[i]
    lineArray = line.split /\s+/
    count = 0
    userName = null
    sessionName = null
    lineArray.forEach (segment) ->
      userName = segment  if count is 0
      if count is 1
        sessionName = segment
        consoleCount = undefined
        if users[userName]
          consoleCount = parseInt users[userName]['sessions']
          consoleCount++
        else
          consoleCount = 1
          users[userName] = {}
          users[userName]["username"] = userName
          users[userName]["type"] = []
        users[userName]["sessions"] = consoleCount
        users[userName]["type"].push sessionName
      count++
    i++
  users

@poll = (utilities, callback) ->
  
  self = this
  self.utilities = utilities
  
  self.utilities.runCommand Plugin.command, (response) ->
   
    data = Plugin.format response
    
    for user of data
      callback Plugin.name, 'Who-' + data[user]['username'], 'Count', data[user]['sessions']
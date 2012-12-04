crypto = require 'crypto'
exec = require('child_process').exec

class Utils
	
  @trace info: () ->

    console.log('Version: ' + process.version)
    console.log('Platform: ' + process.platform)
    console.log('Architecture: ' + process.arch)
    console.log('NODE_PATH: ' + process.env.NODE_PATH)

  @trace runCommand: (command, callback) ->

    child = exec(command, (error, stdout, stderr) ->
      callback new String(stdout).trim()
    )    

  @trace isEmpty: (variable) ->
    
    if variable is 'none' or variable is '' or typeof variable is 'undefined'
      return true
    else
      return false

  @trace md5: (text) ->

    crypto.createHash('md5').update(text).digest('hex')

exports.Utils = Utils
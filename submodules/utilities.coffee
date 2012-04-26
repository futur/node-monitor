fs = require ('fs')
rest = require ('restler')
util = require('util')
exec = require('child_process').exec

Module = {}

class Utilities

  constructor: () ->
  
    Module = this
  
  exitOnError: (message, error) ->
    
    console.log 'Error: ' + message
    console.error 'Stack: ' + error
    process.exit 1
    
  getPlatform: () ->
   
    return process.platform.toString()
    
  runCommand: (command, callback) ->
   
    child = exec(command, (error, stdout, stderr) ->
      console.log 'Ran command: ' + command
      console.log 'stdout: ' + stdout
      console.log 'stderr: ' + stderr
      console.log 'exec error: ' + error  if error isnt null
      callback new String(stdout).trim()
    )   
      
  changeDirectory: (directory) ->
  
    try
      process.chdir directory
    catch error
      Module.exitOnError 'Error switching to plugins directory', error
      
  parseFileAtNewline: (file) ->
    
    try
      return fs.readFileSync(file, 'ascii').split('\n')
    catch error
      Module.exitOnError 'Error reading monitor config file, exiting application', error
      
  emptyFile: (file, callback) ->
  
    fs.writeFile file, '', (error) ->
    
      callback 'Ok' unless error
      
  parseFileAtNewlineAndEquals: (file) ->
    
    contents = {}
    
    try
      splitBuffer = fs.readFileSync(file, 'ascii')
      console.log 'Found line: ' + splitBuffer
      line = 0
      while line < splitBuffer.length
        console.log 'Found config option: ' + params[0]
        params = file[line].split('=')  
        if Module.isEmpty 
          console.log 'Ignoring empty line'
        else 
          contents[params[0].trim()] = params[1].trim()
        line++
      
      return contents
    catch error
      Module.exitOnError 'Error reading monitor config file, exiting application', error

  parseCommandLineOptions: (argv) ->
  
    console.log 'ec2 arg: ' + argv.ec2
    console.log 'cloudwatch arg: ' + argv.cloudwatch
    
    process.env['ec2'] = argv.ec2.toString().trim()  
    process.env['cloudwatch'] = argv.cloudwatch.toString().trim()
    
    console.log 'Set env ec2 prop: ' + process.env['ec2']
    console.log 'Set env cloudwatch prop: ' + process.env['cloudwatch']
    
    return

  parseConfig: () ->
  
    console.log 'Attempting to parse config...'
    
    try
      process.chdir '../config'
    catch error
      Module.exitOnError 'Error switching to config directory, exiting application', error
  
    try
      contents = Module.parseFileAtNewlineAndEquals 'monitor_config'
      for i in contents
        console.log 'Found config options: ' + i + ', ' + contents[i]
        process.env[i] = contents[i]
      return
    catch exception
      Module.exitOnError 'Error reading monitor config file, exiting application', error
      
    return

  setCredentialsFromFile: (keyFile, secretFile) ->
    
    credentials = {}
    
    try
      console.log 'Key file: ' + keyFile
      credentials['key'] = fs.readFileSync(keyFile, 'ascii').trim()
    catch error
      console.log 'There was an error reading AWS key: ' + error
      
    try
      console.log 'Secret file: ' + secretFile
      credentials['secret'] = fs.readFileSync(secretFile, 'ascii').trim()
    catch error
      console.log 'There was an error reading AWS secret: ' + error
      
    process.env['AWS_ACCESS_KEY_ID'] = credentials.key
    process.env['AWS_SECRET_ACCESS_KEY'] = credentials.secret
    
    console.log 'Found AWS credentials: ' + credentials.key + ', ' + credentials.secret
  
    return credentials
    
  getAwsKey: () ->
    
    return process.env['AWS_ACCESS_KEY_ID']
  
  getAwsSecret: () ->
    
    return process.env['AWS_SECRET_ACCESS_KEY']
    
  setAwsConstants: (callback) ->
  
    Module.setInstanceId ->
    
      Module.setPublicHostname ->
    
        Module.setPrivateIp ->
        
          callback 'Ok'

  setInstanceId: (callback) ->
      
    if process.env['ec2'] is 'true'
      Module.runCommand '../bin/ec2-metadata --instance-id | awk \'{print$2}\'', (response) ->
      
        console.log 'Found InstanceId' + response
        process.env['InstanceId'] = response
        callback response
    else 
      process.env['InstanceId'] = '127.0.0.1'
      callback '127.0.0.1'
      
  getInstanceId: () ->
    
    return process.env['InstanceId']
      
  setPublicHostname: (callback) ->
    
    if process.env['ec2'] is 'true'
      Module.runCommand '../bin/ec2-metadata --public-hostname | awk \'{print$2}\'', (response) ->
          
        console.log 'Found PublicHostname' + response
        process.env['PublicHostname'] = response
        callback response
    else
      process.env['PublicHostname'] = '127.0.0.1'
      callback '127.0.0.1'
          
  getPublicHostname: () ->
    
    return process.env['PublicHostname']

  setPrivateIp: (callback) ->
    
    if process.env['ec2'] is 'true'
      Module.runCommand '../bin/ec2-metadata --local-ipv4 | awk \'{print$2}\'', (response) ->
          
        console.log 'Found PrivateIp' + response
        process.env['PrivateIp'] = response
        callback response
    else 
      process.env['PrivateIp'] = '127.0.0.1'
      callback '127.0.0.1'
          
  getPrivateIp: () ->
    
    return process.env['PrivateIp']
    
  getCloudwatchNamespace: () ->
    
    return process.env['cloudwatch_namespace']
   
  isCloudwatchEnabled: () ->
    
    if process.env['cloudwatch'] is 'true'
      return true
    else 
      return false
    
  getPluginPollTime: () ->
  
    return Number process.env['plugin_poll_time']

  isEven: (number) ->
    
    if number % 2 is 0
      return true
    else
      return false
      
  isEc2: () ->
    
    if process.env['ec2'] is 'true'
      return true
    else 
      return false
         
  isLoneType: (type) ->
    
    if type is 'lone'
      return true 
    else 
      return false

  isPollType: (type) ->
    
    if type is 'poll'
      return true 
    else 
      return false

  isSelfPollType: (type) ->
      
    if type is 'self-poll'
      return true 
    else 
      return false

  validateType: (type) ->
    
    if type is 'poll' or type is 'lone' or type is 'self-poll'
      return true
    else
      return false

  isEmpty: (variable) ->
    
    if variable is 'none' or variable is '' or typeof variable is 'undefined'
      return true
    else
      return false
      
  get: (url, callback) ->
  
    callback result
    
exports.Utilities = Utilities
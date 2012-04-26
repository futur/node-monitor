# To run: coffee utilities --ec2 false --cloudwatch false

argv = require('optimist').usage('Usage: coffee utilities -ec2 [boolean] -cloudwatch [boolean]').demand([ 'ec2', 'cloudwatch' ]).argv

utilities = require '../submodules/utilities'
utilities = new utilities.Utilities

process.env['dir'] = '/Users/franklovecchio/Desktop/development/m2mIO-node-monitor/run'

utilities.parseCommandLineOptions argv

utilities.setCredentialsFromFile 'aws_key', 'aws_secret' 
  
console.log 'AWS key: ' + utilities.getAwsKey()
console.log 'AWS secret: ' + utilities.getAwsSecret()

utilities.setAwsConstants (status) ->
     
  console.log 'Set AWS Instance constants! ' + status
  
  utilities.parseConfig()

  console.log 'Platform: ' + utilities.getPlatform()
    
  utilities.setInstanceId (instanceId) ->
     
    console.log 'InstanceId: ' + utilities.getInstanceId()
   
  utilities.setPublicHostname (publicHostname) ->

    console.log 'Public DNS: ' + utilities.getPublicHostname()

  utilities.setPrivateIp (privateIp) ->

    console.log 'PrivateIP: ' + utilities.getPrivateIp()

  console.log 'CloudWatch Namespace: ' + utilities.getCloudwatchNamespace()

  console.log 'CloudWatch enabled? ' + utilities.isCloudwatchEnabled()

  console.log 'Plugin poll time: ' + utilities.getPluginPollTime()
	
  console.log 'Is even? ' + utilities.isEven 2

  console.log 'Is EC2? ' + utilities.isEc2()

  console.log 'Is lone type? ' + utilities.isLoneType 'lone'
  console.log 'Is lone type? ' + utilities.isLoneType 'not'
	
  console.log 'Is self-poll type? ' + utilities.isSelfPollType 'self-poll'
  console.log 'Is self-poll type? ' + utilities.isSelfPollType 'not'
	
  console.log 'Validate type? ' + utilities.isSelfPollType 'random'
	
  console.log 'Is empty? ' + utilities.isEmpty ''
  console.log 'Is empty? ' + utilities.isEmpty 'no'
    
   # utilities.changeDirectory '../config' (response) ->

     # console.log 'Changed directory!'   
  
   # utilities.runCommand 'cat ../config/monitor_config' (response) ->

     # console.log 'Config file: ' + response 
    
   # utilities.parseFileAtNewline 'monitor_config' (contents) ->

     # for key of contents
       # console.log 'Key: ' + key + ', Value: ' + contents[key]
        
   # utilities.parseFileAtNewlineAndEquals 'monitor_config' (contents) ->

     # for key of contents
       # console.log 'Key: ' + key + ', Value: ' + contents[key]
         
   # utilities.get = (url, callback) ->
      
   # utilities.exitOnError 'message', 'error'
   
   # utilities.emptyFile = (file, callback) ->

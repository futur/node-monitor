# To run: coffee monitor ec2=true/false cloudwatch=true/false plugin=<plugin>

fs = require 'fs'
require 'long-stack-traces'

# Dynamic loading of custom modules
modules =
  utilities: '../submodules/utilities'
  cloudwatch: '../modules/cloudwatch'
  plugins: '../modules/plugins'

for module of modules
  eval module + ' = require(\'" + modules[module] + "\')'
  
process.on 'uncaughtException', (error) ->
  console.log 'Caught unhandled node.js exception: ' + error

class NodeMonitor

  constructor: () ->
    init ->
      @plugins.start

  # Initialize the monitor
  init: (callback) ->
  
    process.env['dir'] = process.cwd()
  
    utilities = new utilities.Utilities constants 
    cloudwatch = new cloudwatch.Cloudwatch constants, utilities
    
    /* Plugins need to be accessible globally */
    @plugins = new plugins.Plugins utilities, cloudwatch
    
    /* Store in process.env all config options from monitor.config file */
    utilities.parseConfig
    
    /* Store in process.env all command line options */
    utilities.parseCommandLineOptions ->
    
      /* Run ec2-metadata script and store all AWS constants in process.env */
      utilities.setAwsConstants    
      
      callback
            
monitor = new NodeMonitor.init
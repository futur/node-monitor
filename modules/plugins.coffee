fs = require 'fs'
express = require 'express'

Module = 
  plugins: {} 
  interface: null
  pluginCount: 0

class Plugins 

  constructor: (utilities, cloudwatch) ->
  
    Module = this
    Module.utilities = utilities
    Module.cloudwatch = cloudwatch

  start: () ->

    Module.utilities.changeDirectory './plugins'
  
    # Read all files in the 'plugin' directory
    plugins = fs.readdirSync(process.cwd())
 
    plugins.forEach (plugin) ->

      # Ignore possible configuration files
      if plugin.indexOf '_config' is -1
        plugin = plugin.split '.'[0]
        loadedPlugin = require process.cwd() + '/' + plugin
        Module.plugins[loadedPlugin.name] = loadedPlugin
      
        # Only allow specified types!
        Module.utilities.exitOnError 'Plugin type is not defined' unless Module.utilities.validateType(loaded.type)
      
        console.log 'Loaded plugin: ' + loadedPlugin.name.toString + ', of type: ' + loadedPlugin.type
        Module.pluginCount++

      console.log Module.pluginCount + ' plugin(s) loaded!'
    
      # Start inteface server
      Module.interface
 
  interface: () ->
  
    app = express.createServer
    app.configure ->
    
      app.use express.methodOverride()
      app.use express.bodyParser()
      app.use app.router
      app.set 'view options',
        layout: false
        app.use express.errorHandler(
          dumpExceptions: true
          showStack: true
        )
      
    app.renderJson = (status, message, detail) ->
    
      response =
        Status: status
        Message: message
        Detail: detail

      response

    app.post '/monitor', (request, response) ->
    
      console.log 'node-monitor interface request'
    
      request.params.metricName
      request.params.value
      request.params.unit
      
      Module.cloudwatch.post metricName, unit, value
    
      response.json app.renderJson('200', 'Success', 'Instance: ' + instanceId + ' terminated successfully.')

    app.listen 8081
      
    Module.interface = app 
    
    # Start plugins!
    Module.execute

  execute:() ->
  
    for plugin of Module.plugins
      console.log 'Found plugin of type' + Module.plugins[plugin].type
    
      # Handle self-polling or single-instation plugins
      if Module.utilities.isLoneType(Module.plugins[plugin].type)
        Module.plugins[plugin].run Module.utilities, (pluginName, metricName, unit, value) ->
        
          Module.cloudwatch.post metricName, unit, value
        
      if Module.utilities.isSelfPollType(Module.plugins[plugin].type)
        setInterval (->
          unless Module.utilities.isLoneType(Module.plugins[plugin].type)
            Module.plugins[plugin].run Module.utilities, (pluginName, metricName, unit, value) ->
            
              Module.cloudwatch.post metricName, unit, value
            
        ), Number(Module.plugins[plugin].period) * 1000
      
    # Poll-time is usually set to 5 minutes, so as to not incur CloudWatch charges
    setInterval (->
      for plugin of Module.plugins
        if Module.utilities.isPollType(Module.plugins[plugin].type)
          console.log 'Running polling plugin: ' + plugin
          Module.plugins[plugin].poll Module.utilities, (pluginName, metricName, unit, value) ->
          
            Module.cloudwatch.post metricName, unit, value
          
    ), Module.utilities.getPluginPollTime * 1000

exports.Plugins = Plugins
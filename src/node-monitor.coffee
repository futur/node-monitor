# Reset console.
console.log '\x1B[0m'

Base = require process.cwd() + '/src/lib/base'
Config = require process.cwd() + '/src/lib/config'
Plugins = require process.cwd() + '/src/lib/plugins'

class NodeMonitor extends Base

  loadConfig: (cb) ->

    ### Load configuration from a file. ###

    config = new Config(
      (err) =>
        @err err
      (config) ->
        # Set config globally.
        process.env.config = JSON.stringify(config)
        cb()
    )

  runApiInterface: (cb) ->

    ### Run the API interface. ###

    express = require 'express'
    
    # Configure the server.
    api = express()
    api.configure () ->
      api.use express.bodyParser()
      api.use express.methodOverride()
      api.use api.router

    # A single access point for the API interface.
    api.post '/', (req, res) =>
      @emit 'api', req, res
      res.send 200, '{"status":"ok"}'

    api.listen 3000, () -> 
      process.env.api = api
      cb()

  runPlugins: (cb) ->

    ### Run plugins. ###

    plugins = new Plugins(
      (err) =>
        @err err
      () ->
        cb()
    )

  interfaces: (cb) ->

    ### Testing. ###

    @on 'plugins:cpu', (cpu) ->
      console.log 'plugins:cpu -> ' + cpu

    @on 'plugins:memory', (memory) ->
      console.log 'plugins:memory -> ' + memory

    cb()

monitor = new NodeMonitor()
monitor.loadConfig () ->
  monitor.runApiInterface () ->
    monitor.interfaces () ->
      monitor.runPlugins () ->
        monitor.log monitor.messages.PLUGINS_LOADED, monitor.green
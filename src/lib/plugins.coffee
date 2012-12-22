Base = require process.cwd() + '/src/lib/base'

class Plugins extends Base

  loaded: { }
  available: [ ]

  constructor: (cbErr, cbSuccess) ->

    @available = @readPluginsDirectory()

    @_.each @available, (pluginName) =>
      @getPluginConfig(
        @filterCoffeeSuffix(pluginName)
        (pluginName) =>
          @log @errors.NO_PLUGIN_CONFIG, @red, pluginName
          @runPlugin pluginName
        (pluginName, config) =>
          @log @messages.FOUND_PLUGIN_CONFIG, @green, pluginName
          @runPlugin pluginName, config
      )

  readPluginsDirectory: () ->

    @fs.readdirSync process.cwd() + '/src/plugins'

  getPluginConfig: (pluginName, cbErr, cbSuccess) ->

    if @config().plugins[pluginName] is undefined
      cbErr pluginName
    else
      cbSuccess pluginName, @config().plugins[pluginName]

  runPlugin: (pluginName, config) ->

    Plugin = require process.cwd() + '/src/plugins/' + pluginName + '.coffee'

    if config is undefined
      config = { }

    console.log config

    new Plugin(
      config
      (err) =>
        @log @messages.PLUGIN_LOAD_ERROR, @red, pluginName
        @loaded[pluginName] = false
      (pluginName) =>
        @loaded[pluginName] = new Date().getTime() 
    )

module.exports = Plugins
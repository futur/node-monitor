Base = require process.cwd() + '/src/lib/base'

class Plugins extends Base

  loaded: { }
  available: [ ]

  constructor: (cb) ->

    ### Read plugin directory, get configs (if applicable), run plugins. ###

    @available = @readPluginsDirectory()

    @_.each @available, (pluginName) =>
      @getPluginConfig(
        @filterCoffeeSuffix pluginName
        (pluginName) =>
          @log @errors.NO_PLUGIN_CONFIG, @red, pluginName
          @runPlugin pluginName
        (pluginName, config) =>
          @log @messages.FOUND_PLUGIN_CONFIG, @green, pluginName
          @runPlugin pluginName, config
      )

    cb()

  readPluginsDirectory: () ->

    ### Read all plugin files. ###

    @fs.readdirSync process.cwd() + '/src/plugins'

  getPluginConfig: (pluginName, cbErr, cbSuccess) ->

    ### Read plugin config. ###

    if @getGlobalConfig().plugins[pluginName] is undefined
      cbErr pluginName
    else
      cbSuccess pluginName, @getGlobalConfig().plugins[pluginName]

  runPlugin: (pluginName, config) ->

    ### Instantiate plugin. ###

    Plugin = require process.cwd() + '/src/plugins/' + pluginName + '.coffee'

    if config is undefined
      config = { }

    new Plugin(
      config
      (err) =>
        @log @messages.PLUGIN_LOAD_ERROR, @red, pluginName
        @loaded[pluginName] = false
      (interval) =>
        @loaded[pluginName] = interval
    )

  stopPlugin: (pluginName) ->

    ### Stop a running plugin. ###

    clearInterval @loaded[pluginName]

    @log @messages.PLUGIN_STOPPED, @red, pluginName
    @loaded[pluginName] = false

  addPluginFromUrl: (pluginName) ->

    ### Add plugin. ###

    ### Where does config come from? ###

  deletePlugin: (pluginName) ->

module.exports = Plugins
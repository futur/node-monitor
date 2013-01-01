PluginInterface = require process.cwd() + '/src/lib/plugin'

class Plugin extends PluginInterface

  run: () ->

    ### Plugin and interface. ###

    @log 'plugins:cpu', @green

    @emit 'plugins:cpu', '10'

module.exports = Plugin
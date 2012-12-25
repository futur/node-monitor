PluginInterface = require process.cwd() + '/src/lib/plugin'

class Plugin extends PluginInterface

  run: () ->

    ### Plugin and interface. ###

    @emit 'plugins:cpu', '10'

module.exports = Plugin
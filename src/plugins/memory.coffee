PluginInterface = require process.cwd() + '/src/lib/plugin'

class Plugin extends PluginInterface

  run: () ->

    ### Plugin and interface. ###

    @log 'plugins:memory', @green

    @emit 'plugins:memory', '10'

module.exports = Plugin
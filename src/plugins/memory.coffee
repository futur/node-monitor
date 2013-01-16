PluginInterface = require process.cwd() + '/src/lib/plugin'

class Plugin extends PluginInterface

  run: (cb) ->

    ### Plugin and interface. ###

    @log 'plugins:memory', @green

    if cb
      cb @os.freemem()
    @emit 'plugins:memory', @os.freemem()

module.exports = Plugin
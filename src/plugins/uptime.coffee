PluginInterface = require process.cwd() + '/src/lib/plugin'

class Plugin extends PluginInterface

  run: (cb) ->

    ### Plugin and interface. ###

    @log 'plugins:uptime', @green

    if cb
      cb @os.uptime()
    @emit 'plugins:uptime', @os.uptime()

module.exports = Plugin
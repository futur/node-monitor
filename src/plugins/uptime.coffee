PluginInterface = require process.cwd() + '/src/lib/plugin'

class Plugin extends PluginInterface

  run: (cb) ->

    ### Plugin and interface. ###

    @log 'plugins:uptime', @green

    if cb
      cb @os.uptime()
    process.monitor.emit 'plugins:uptime', @format(@os.uptime()), 'seconds'

  format: (ms) ->

    ### Format. ###

    ms / (60 * 1000 * 1000)

module.exports = Plugin
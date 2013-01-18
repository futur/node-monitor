PluginInterface = require process.cwd() + '/src/lib/plugin'

class Plugin extends PluginInterface

  run: (cb) ->

    ### Plugin and interface. ###

    @log 'plugins:load', @green

    if cb
      cb @os.loadavg()
    process.monitor.emit 'plugins:load', @os.loadavg()

module.exports = Plugin
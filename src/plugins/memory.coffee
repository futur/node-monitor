PluginInterface = require process.cwd() + '/src/lib/plugin'

class Plugin extends PluginInterface

  run: (cb) ->

    ### Plugin and interface. ###

    @log 'plugins:memory', @green

    if cb
      cb @format(@os.freemem())
    process.monitor.emit 'plugins:memory', @format(@os.freemem()), 'mb'

  format: (bytes) ->

    ### Format. ###

    bytes / 1024

module.exports = Plugin
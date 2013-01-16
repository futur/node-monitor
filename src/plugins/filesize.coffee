PluginInterface = require process.cwd() + '/src/lib/plugin'

class Plugin extends PluginInterface

  run: (cb) ->

    ### Plugin and interface. ###

    @log 'plugins:filesize', @green

    @_.each @config.files, (file) =>
      @fs.stat file.name, (error, stat) =>
        if cb
          cb file.name, file.maxSize, stat.size
        @emit 'plugins:filesize', file.name, file.maxSize, stat.size

module.exports = Plugin
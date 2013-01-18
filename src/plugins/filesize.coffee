PluginInterface = require process.cwd() + '/src/lib/plugin'

class Plugin extends PluginInterface

  run: (cb) ->

    ### Plugin and interface. ###

    @log 'plugins:filesize', @green

    @_.each @config.files, (file) =>
      path = file[0]
      maxSize = file[1]
      @log 'Checking filesize: ' + path + ', max: ' + maxSize
      @fs.stat path, (error, stat) =>
        if cb
          cb path, maxSize, stat.size
        process.monitor.emit 'plugins:filesize', path, maxSize, stat.size

  format: (bytes) ->

    ### Format. ###

    bytes / 1024

module.exports = Plugin
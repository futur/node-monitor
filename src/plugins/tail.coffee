PluginInterface = require process.cwd() + '/src/lib/plugin'

class Plugin extends PluginInterface

  run: (config) ->

    ### Tail files and push to an event. ###

    @log 'plugins:tail', @green

    @_.each config.files, (file) =>
      command = 'tail -F ' + file
      tail = @spawn command
      console.log 'file: ' + file + ', PID: ' + tail.pid 
      tail.stdout.on 'data', (data) ->
        console.log file + ', data: ' + data

      #@emit 'plugins:tail', file, @format(stdout)

module.exports = Plugin
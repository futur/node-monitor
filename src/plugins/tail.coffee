PluginInterface = require process.cwd() + '/src/lib/plugin'

class Plugin extends PluginInterface

  run: (cb) ->

    ### Tail files and push to an event. ###

    @log 'plugins:tail', @green

    @_.each @config.files, (file) =>
      @log 'Watching file: ' + file
      @fs.watchFile file, (curr, prev) =>
        # Only works on append.
        return clear: true  if prev.size > curr.size
        stream = @fs.createReadStream(file,
          start: prev.size
          end: curr.size
        )
        stream.addListener 'data', (lines) =>
          lines = lines.toString('utf-8').split('\n')
          line = ''
          if lines[1]
            line = lines[1]
          else
            line = lines[0]
          if cb
            cb file, line
          @emit 'plugins:tail', file, line
    
module.exports = Plugin
PluginInterface = require process.cwd() + '/src/lib/plugin'

class Plugin extends PluginInterface

  run: (cb) ->

    ### Plugin and interface. ###

    @log 'plugins:cpu', @green

    @log 'platform: ' + @info().platform, @green
     
    switch @info().platform
      when 'darwin'
        command = '?'
      when 'linux'
        command = 'top -b -n 1 | awk \'NR==3{print$2}\''
  
    if cb
      cb '10'
    @emit 'plugins:cpu', '10'

module.exports = Plugin
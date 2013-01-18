PluginInterface = require process.cwd() + '/src/lib/plugin'

class Plugin extends PluginInterface

  run: (cb) ->

    ### Plugin and interface. ###

    @log 'plugins:processes', @green

    switch @info().platform
      when 'darwin'
        command = 'top -l 1 | awk \'NR==1{print$2}\''
      when 'linux'
        command = 'top -b -n 1' # | awk \'NR==3{print$2}\''

    @cmd command, (stdout, pid) =>
      if cb
        cb stdout
      process.monitor.emit 'plugins:processes', stdout

module.exports = Plugin
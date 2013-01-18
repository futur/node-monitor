PluginInterface = require process.cwd() + '/src/lib/plugin'

class Plugin extends PluginInterface

  run: (cb) ->

    ### Plugin and interface. ###

    @log 'plugins:cpu', @green

    switch @info().platform
      when 'darwin'
        command = 'top -l 1 | awk \'NR==4{print$7}\''
      when 'linux'
        command = 'top -b -n 1 | awk \'NR==3{print$2}\''

    @cmd command, (stdout, pid) =>
      if cb
        cb @format(stdout)
      process.monitor.emit 'plugins:cpu', @format(stdout)
  
  format: (stdout) ->

    ### Format. ###

    switch @info().platform
      when 'darwin'
        stdout = 100 - parseInt(stdout.replace '%', '')

    stdout

module.exports = Plugin
PluginInterface = require process.cwd() + '/src/lib/plugin'

class Plugin extends PluginInterface

  run: (cb) ->

    ### Get disk usage in percentage. ###

    @log 'plugins:df', @green

    @_.each @config.disks, (disk) =>
      command = 'df -h | grep -v grep | grep \'' + disk + '\' | awk \'{print $5}\''
      @cmd command, (stdout, pid) =>
        if cb
          cb disk, @format(stdout)
        process.monitor.emit 'plugins:df', disk, @format(stdout)

  format: (stdout) ->

    ### Format. ###

    stdout.replace '%', ''

module.exports = Plugin
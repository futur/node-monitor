PluginInterface = require process.cwd() + '/src/lib/plugin'

class Plugin extends PluginInterface

  run: () ->

    ### Get disk usage in percentage. ###

    @log 'plugins:df', @green

    @_.each @config.disks, (disk) =>
      command = 'df -h | grep -v grep | grep \'' + disk + '\' | awk \'{print $5}\''
      @cmd command, (stdout, pid) =>
        @emit 'plugins:df', disk, @format(stdout)

  format: (stdout) ->

    ### Format stdout. ###

    stdout.replace '%', ''

module.exports = Plugin
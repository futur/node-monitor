PluginInterface = require process.cwd() + '/src/lib/plugin'

class Plugin extends PluginInterface

  run: (config) ->

    ### Get disk usage in percentage. ###

    @_.each config.disks, (disk) =>
      command = 'df -h | grep -v grep | grep \'' + disk + '\' | awk \'{print $5}\''
      @cmd command, (stdout) =>
        @emit 'plugins:df', disk, @format(stdout)

  format: (stdout) ->

    ### Format stdout. ###

    stdout.replace '%', ''

module.exports = Plugin
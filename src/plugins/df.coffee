PluginInterface = require process.cwd() + '/src/lib/plugin'

class Plugin extends PluginInterface

  run: (config) ->

    ### Plugin and interface. ###

    @_.each config.disks, (disk) =>
      command = 'df -h | grep -v grep | grep \'' + disk + '\' | awk \'{print $5}\''
      @cmd command, (stdout) =>
        @handler disk, @format(stdout)

  format: (stdout) ->

    ### Format stdout. ###

    stdout.replace '%', ''

  handler: (disk, usage) ->

    ### Command callback. ###
    
    @emit 'plugins:df', disk, usage

module.exports = Plugin
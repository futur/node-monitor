Base = require process.cwd() + '/src/lib/base'

class Plugin extends Base

  constructor: (config, cbErr, cbSuccess) ->

    ### Handle config and set interval. ###

    if !config.poll
      poll = @config().app.poll
    else
      poll = config.poll

    setInterval (=>
      @runPlugin(config)
    ), poll * 1000

    cbSuccess()

  runPlugin: (config) ->

    ### Plugin and interface. ###

    @_.each config.disks, (disk) =>
      command = 'df -h | grep -v grep | grep \'' + disk + '\' | awk \'{print $5}\''
      @run command, (stdout) =>
        @handler disk, @format(stdout)

  format: (stdout) ->

    stdout.replace '%', ''

  handler: (disk, df) ->

    @log 'Disk: ' + disk, @green
    @log 'Size: ' + df, @green
    
    @emit 'plugins:df', disk, df

module.exports = Plugin

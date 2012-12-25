Base = require process.cwd() + '/src/lib/base'

class PluginInterface extends Base

  constructor: (config, cbErr, cbSuccess) ->

    ### Handle config and set interval. ###

    if !config.poll
      poll = @config().app.poll
    else
      poll = config.poll

    intervalId = setInterval (=>
      @run config # Subclass method.
    ), poll * 1000

    console.log JSON.stringify(intervalId)
    
    cbSuccess()

module.exports = PluginInterface
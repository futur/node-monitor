Base = require process.cwd() + '/src/lib/base'

class PluginInterface extends Base

  constructor: (@config, cbErr, cbSuccess) ->

    ### Handle config and set interval. ###

    if !@config.poll
      poll = @getGlobalConfig().app.poll
    else
      poll = @config.poll

    interval = setInterval (=>
      @run() # Subclass method.
      cbSuccess interval
    ), poll * 1000

module.exports = PluginInterface
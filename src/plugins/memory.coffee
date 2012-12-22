Base = require process.cwd() + '/src/lib/base'

class Memory extends Base

  constructor: (config, cbErr, cbSuccess) ->

    ### Handle config and set interval. ###

    setInterval (=>
      @runPlugin()
    ), 5 * 1000 # TODO config not configured, etc.

    cbSuccess()

  runPlugin: () ->

    ### Plugin and interface. ###

    @emit 'plugins:memory', '10'

module.exports = Memory
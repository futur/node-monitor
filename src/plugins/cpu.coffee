Base = require process.cwd() + '/src/lib/base'

class CPU extends Base

  constructor: (config, cbErr, cbSuccess) ->

    ### Handle config and set interval. ###

    setInterval (=>
      @runPlugin()
    ), 1 * 1000 # TODO config not configured, etc.

    cbSuccess()

  runPlugin: () ->

    ### Plugin and interface. ###

    @emit 'plugins:cpu', '10'

module.exports = CPU
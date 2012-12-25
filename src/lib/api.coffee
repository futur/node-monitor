Base = require process.cwd() + '/src/lib/base'

class ApiInterface extends Base

  constructor: (@api) ->

    ### Set routes based on request. ###

    @on 'api:req', (req, res) ->
      @log 'plugins:api'

module.exports = ApiInterface
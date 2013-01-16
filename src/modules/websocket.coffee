Base = require '../lib/base'

class Websocket extends Base

  constructor: (@port, cbErr, cbSuccess) ->

    @io.listen @port

    @io.sockets.on 'connection', (socket) ->
      @socket = socket

  publish: (message) ->

    @socket.emit message

module.exports = Websocket
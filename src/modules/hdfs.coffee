Base = require '../lib/base'

class HDFS extends Base

  constructor: (@host, @path, cbErr, cbSuccess) ->

    @client = new @hdfs(
      host: @host
      port: 0
    )
   
  insert: (type, message, cbErr, cbSuccess) ->

    ### Insert internal logs into HDFS. ###

    buffer = new Buffer(
      @formatLogMessage(type, message)
    )

    @client.write @path, (writer) ->
      writer.once 'open', (err, handle) ->
        if err 
          cbErr err 
        else
          writer.write buffer
          writer.end()

      writer.once 'close', (err) ->
        if err
          cbErr err 
        else
          cbSuccess()

module.exports = HDFS
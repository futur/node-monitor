Base = require '../lib/base'

class Redis extends Base

  constructor: (cbErr, cbSuccess) ->

    @client = @redis.createClient()

    @client.on 'error', (err) ->
      cbErr err

    cbSuccess()
   
  inser: (type, message) ->

    console.log 'innnnn'

    ### Insert internal logs into Redis using a "day" bucket. ###

    #log = @formatLog(type, message)

    #console.log 'log: ' + log

    # Allow filtering by year, year:month, year:month:day.
    #@client.hset 'node-monitor:' + log.key, log.epoch, log.message
    
module.exports = Redis
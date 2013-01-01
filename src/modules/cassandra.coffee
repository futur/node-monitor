###```
create keyspace node-monitor;
use test;
create column family logs with comparator=UTF8Type and default_validation_class=UTF8Type and key_validation_class=UTF8Type;
```###

Base = require '../lib/base'

class Cassandra extends Base

  constructor: (@hosts, @keyspace, @cf, cbErr, cbSuccess) ->

    @cqlInsert = 'UPDATE ' + @cf + ' USING CONSISTENCY ANY SET \'%s\' = \'%s\' WHERE key = \'%s\''
    @cqlSelect = 'SELECT * FROM ' + @cf + ' WHERE key = ?'

    @pool = new @helenus.ConnectionPool(
      hosts: @hosts
      keyspace: 'node-monitor'
      timeout: 3000
    )

    @pool.on 'error', (err) =>
      cbErr err

    @pool.connect (err, keyspace) =>
      if err
        cbErr err
      else
        cbSuccess @pool

  insert: (type, message) ->

    ### Insert internal logs into Cassandra using a "day" bucket. ###

    log = @formatLog(type, message)

    # Allow filtering by year, year:month, year:month:day.
    @pool.cql @cqlInsert, [log.key, log.epoch, log.message], (err, results) =>
      if err is null
        err = undefined
      if err 
        cbErr err 
      else
        cbSuccess()

module.exports = Cassandra
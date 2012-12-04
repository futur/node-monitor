#
# A persisted key/value filestore for managing configuration.
#

# Interface
{EventEmitter} = require 'events'

# Deps
alfred = require('alfred')

# TODO
# listener for keystore
class Config extends EventEmitter
	
  db: undefined
	
  @trace connect: (cb) ->

    alfred.open './', (error, db) =>
      cb error  if error
      db.ensure 'config', (err, config) =>
        @emit 'log:info', 'config database loaded'
        @db = db
        cb false

  @trace set: (key, value) ->
	
    @db.config.put key, value, (error) ->
      throw error  if error

  @trace get: (key, cb) ->	

    @db.get key, (error, value) =>
      cb value

exports.Config = Config
#
# A persisted key/value filestore for managing configuration.
#

# Common
Utils = require './utils'

# Deps
alfred = require 'alfred'

# TODO
# listener for keystore
class Config extends Utils
	
  db: undefined
	
  @trace init: (cb) ->

    alfred.open './', (error, db) =>
      throw error if error
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

module.exports = Config
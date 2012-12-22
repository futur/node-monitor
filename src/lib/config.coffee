Base = require './base'

class Config extends Base

  constructor: (cbErr, cbSuccess) ->

    ### Read local config. ###

    try
      conf = @cjson.load process.cwd() + '/conf/node-monitor.json'
      cbSuccess conf
    catch err
      cbErr err
    
  save: (key, value) ->

    ### Set a config value. ###

  fetch: (key, cb) ->

    ### Get a config value. ###

module.exports = Config
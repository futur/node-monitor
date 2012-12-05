#
# The monitoring application.
#

# Common
{Plugins} = require './plugins'
{Config} = require './config'.Config

# Deps
alfred = require 'alfred'

class NodeMonitor extends Plugins

  config: undefined
  plugins: { }

  @trace constructor: () ->
	
    process.env['dir'] = process.cwd()
	
    @config = new Config()
    @config.init (error) ->	  
      if !error
        @startMonitoringPlugins()
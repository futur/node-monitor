constants = require '../submodules/constants', 
  utilities = require '../submodules/utilities', 
    # ioutilities = require '../submodules/ioutils', 
      cloudwatch = require '../modules/cloudwatch'
      
constants = new constants.Constants
utilities = new utilities.Utilities constants 
# ioutilities = new ioutilities.IOUtilities constants, utilities
cloudwatch = new cloudwatch.Cloudwatch constants, utilities

plugin = require '../plugins/cpu'

console.log 'Name: ' + plugin.name
console.log 'Type: ' + plugin.type

setInterval (->
  console.log 'Running plugin: ' + plugin
  plugin.poll constants, utilities, ioutilities, (pluginName, metricName, unit, value) ->
    
    console.log 'Metric name: ' + metricName
    console.log 'Unit: ' + unit
    console.log 'Value: ' + value
          
), 10 * 1000

exports.testSomething = (test) ->
  test.expect(1)
  test.ok(true, 'Should pass')
  test.done()

exports.testSomethingElse = (test2) ->
  test2.expect(1)
  test2.ok(false, 'Should fail')
  test2.done()
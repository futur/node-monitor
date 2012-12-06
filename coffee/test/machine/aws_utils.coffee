#
# A test suite for machine/aws_utils.
#

Function::trace = do () =>
  makeTracing = (ctorName, fnName, fn) =>
    (args...) ->
      console.log "TRACE #{ctorName}:#{fnName}"
      fn.apply @, args
  (arg) ->
    for own name, fn of arg 
      @prototype[name] = makeTracing @name, name, fn

AwsUtils = require '../../lib/machine/aws_utils'
utils = new AwsUtils()

utils.TEST()
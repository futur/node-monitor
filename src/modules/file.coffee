Base = require '../lib/base'

class File extends Base

  constructor: (@path) ->

  insert: (type, message) ->

    ### Insert internal logs into a file. ###

    fd = @fs.openSync @path, 'a+', 666

    @fs.writeSync fd, @formatLogMessage(type, message)
    @fs.closeSync fd
    
module.exports = File
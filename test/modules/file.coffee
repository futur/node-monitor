File = require process.cwd() + '/src/modules/file'

### Tests. ###

describe '======= File.class =======', ->
  it 'should write a message to a file', (done) ->

    file = new File(
      '/Users/franklovecchio/Desktop/test.log'
    )
    
    file.insert 'WARNING', 'Some generic message.'

    done()
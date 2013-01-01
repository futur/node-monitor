Plugin = require process.cwd() + '/src/plugins/df'

### Tests. ###

describe '======= tail =======', ->
  it 'should tail log files', (done) ->

    config = 
      'files': [
        '/Users/franklovecchio/Desktop/log1'
        '/Users/franklovecchio/Desktop/log2'
      ]

    console.log config

    plugin = new Plugin(
      config
    )

    plugin.run()

    done()
Plugin = require process.cwd() + '/src/plugins/df'

### Tests. ###

describe '======= df =======', ->
  it 'should get disk space usage', (done) ->

    config = 
      'poll': 1
      'disks': [
        '/dev/disk0s2'
      ]

    plugin = new Plugin(
      config
      (err) ->
        done()
      () ->
        @run()
        #done()
    )

    plugin.on 'plugins:df', (disk, usage) ->
      console.log disk
      done()

    #done()
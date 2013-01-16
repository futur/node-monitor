Plugin = require process.cwd() + '/src/plugins/uptime'

### Tests. ###

describe '======= uptime =======', ->
  it 'should get uptime', (done) ->

    config = { }

    plugin = new Plugin(
      config
      (err) ->
        done()
      () ->
        @on 'plugins:uptime', (uptime) ->
          console.log uptime
          done()
        @run (uptime) ->
          console.log 'callback: ' + JSON.stringify(uptime)
    )
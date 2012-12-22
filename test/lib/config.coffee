Config = require process.cwd() + '/src/lib/config'

### Setup. ###


### Tests. ###

describe '======= Config.class =======', ->
  it 'should connect ok', (done) ->

    config = new Config(
      (err) ->
        console.log err
      () ->
        console.log 'ok'
        done()
    )

  ###
  it 'should log green', (done) ->

    test = new Test()
    test.log 'green', test.green

    done()

  it 'should log bold', (done) ->

    test = new Test()
    test.log 'bold', test.bold

    done()###
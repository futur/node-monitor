Base = require process.cwd() + '/src/lib/base'

### Setup. ###

class Test extends Base

### Tests. ###

describe '======= Base.class =======', ->
  it 'should log red', (done) ->

    test = new Test()
    test.log 'red', test.red

    done()

  it 'should log green', (done) ->

    test = new Test()
    test.log 'green', test.green

    done()

  it 'should log bold', (done) ->

    test = new Test()
    test.log 'bold', test.bold

    done()
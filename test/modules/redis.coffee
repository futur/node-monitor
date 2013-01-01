Redis = require process.cwd() + '/src/modules/redis'

### Tests. ###

describe '======= Redis.class =======', ->
  it 'should write a message to Redis', (done) ->

    redis = undefined

    write = () ->

      console.log 'write'

      redis.inser 'WARNING', 'Some generic message.'

    redis = new Redis(
      (err) ->
        console.log err 
        done()
      () ->
        done()
    )
HDFS = require process.cwd() + '/src/modules/hdfs'

### Tests. ###

describe '======= HDFS.class =======', ->
  it 'should write a message to hdfs', (done) ->

    hdfs = new HDFS(
      'default'
      '/Users/franklovecchio/Desktop/hdfs'
      (err) ->
        console.log err 
        done()
      () ->
        hdfs.insert(
          'WARNING'
          'Some generic message.'
          (err) ->
            console.log err 
            done()
          () ->
            done()
    )
client = new Db(
  'test'
  new Server(
    '127.0.0.1'
    27017
    {}
  )
)

test = (err, collection) ->
  collection.insert
    a: 2
  , (err, docs) ->
    collection.count (err, count) ->
      test.assertEquals 1, count

    
    # Locate all the entries using find
    collection.find().toArray (err, results) ->
      test.assertEquals 1, results.length
      test.assertTrue results[0].a is 2
      
      # Let's close the db
      client.close()



client.open (err, p_client) ->
  client.collection 'test_insert', test



###```
create keyspace test;
use test;
create column family test with comparator=UTF8Type and default_validation_class=UTF8Type and key_validation_class=UTF8Type;
```###

Base = require '../lib/base'

class Mongo extends Base

  constructor: (@hosts) ->

  connect: (cbErr, cbSuccess) ->

  insert: () ->

    ### Insert data. ###

    switch arguments.length
      when 2

        ### Insert JSON with rows specified. ###

      when 4

        ### Insert simpl key/value pair. ###

  read: (row, cbErr, cbSuccess) ->

    ### Get data. ###
    
module.exports = Mongo
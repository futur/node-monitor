Base = require '../lib/base'

class Solr extends Base

  constructor: (@host) ->

    config: '<docs><doc><field name="id">1</field><field name="fizzbuzz_t">foo</field><field name="wakak_i">5</field></doc></docs>'

  connect: (config, cbErr, cbSuccess) ->

    @client = @solr.createClient()

    @client.on 'error', (err) =>
      cbErr err

    client.post 'analysis/document', @config (err, res) ->
      if err 
        cbErr err
      else
        cbSuccess()

  insert: (data, cbErr, cbSuccess) ->

    ### Insert data. ###

    doc = 
      'date': new Date().getTime()
      'log': JSON.stringify(data)

    @client.add doc1, (err) ->
      if err
        cbErr err
      else
        @client.commit (err) ->
          if err 
            cbErr err 
          else
            cbSuccess()

  read: (query, cbErr, cbSuccess) ->

    ### Get data. ###

    @client.query query, (err, response) ->
      if err 
        cbErr err 
      else
        cbSuccess JSON.parse(response)
    
module.exports = Solr




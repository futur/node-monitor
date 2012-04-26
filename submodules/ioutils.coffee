fs = require 'fs'
email = require 'email'.Email

Module = {}

class IOUtilities
 
  constructor: (utilities) ->
  
  Module = this
  Module.utilities = utilities
    
  getToken: (callback) ->
    
    Module.utilities.runCommand 'cat /home/ubuntu/token', response ->
      
      callback response

  isKeyspaceToMonitor: (keyspace) ->
    
    keyspaces = []
    keyspaces.push '/mnt/cassandra/data/dse_system'
    keyspaces.push '/mnt/cassandra/data/system'
    keyspaces.push '/mnt/cassandra/data/cfs'
    keyspaces.push '/mnt/cassandra/data/OpsCenter'
    if keyspaces.contains keyspace
      return false
    else
      return true

  getCustomerPrefix: (callback) ->
    
    if Module.utilities.isEc2
      Module.utilities.runCommand 'cat /home/ubuntu/prefix', response ->
         
        callback response
  
  sendMail: (fromAddress, toAddress, mySubject, message) ->

    myMsg = new Email(
      from: fromAddress
      to: toAddress
      subject: mySubject
      body: myMessage
    )
    myMsg.send (error) ->

exports.IOUtilities = IOUtilities
Sequelize = require 'sequelize'

Log = sequelize.define('Log',
  key: Sequelize.STRING
  message: Sequelize.STRING
  epoch: Sequelize.
,
  instanceMethods:
    getFullname: () ->

      [@firstname, @lastname].join ' '
)

Base = require '../lib/base'

class Postgres extends Base

  constructor: (@database, @port, @username, @password) ->

    @sequelize = new Sequelize(@database, @username, @password,
      dialect: 'postgres'
      port: @port
      define:
        underscored: false
        timestamps: true
      sync:
        force: true
      syncOnAssociation: true
      pool:
        maxConnections: 5
        maxIdleTime: 30
    )

    cbSuccess()

  insert: (type, message) ->

    ### Insert internal logs into Cassandra using a "day" bucket. ###

    log = @formatLog(type, message)

    #mlog.key, log.epoch, log.message

    # Allow filteringf by year, year:month, year:month:day.
    @pool.cql @cqlInsert, [log.key, log.epoch, log.message], (err, results) =>
      if err is null
        err = undefined
      if err 
        cbErr err 
      else
        cbSuccess()

module.exports = Postgres





###
first name
last name
email
zip code
company name
google+
skype
phone
about
linkedin profile url
company url
###

User = sequelize.define('User',
  firstname: Sequelize.STRING
  lastname: Sequelize.STRING
,
  instanceMethods:
    getFullname: () ->

      [@firstname, @lastname].join ' '
)

###sequelize.drop().success(->
  console.log 'Tables dropped.'
).error (error) ->
  console.log 'Tables drop error: ' + error
2
sequelize.sync().success(->
  console.log 'Tables synced.'
).error (error) ->
  console.log 'Tables sync error: ' + error###

###sequelize.sync 
  force: true###

User.build(
  firstname: 'Frank'
  lastname: 'LoVecchio'
).save().success((anotherTask) ->
  console.log 'User saved.'
).error (error) ->
  console.log 'User saved error: ' + error
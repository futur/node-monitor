{EventEmitter} = require 'events'
fs = require 'fs'
rest = require 'restler'
_ = require 'underscore'
path = require 'path'
cjson = require 'cjson'
crypto = require 'crypto'
df = require 'dateformat'
exec = require('child_process').exec
spawn = require('child_process').spawn
helenus = require 'helenus'
redis = require 'redis'
#hdfs = require 'node-hdfs'
solr = require 'solr'
cloudwatchApi = require 'node-cloudwatch'

class Base extends EventEmitter

  fs: fs
  rest: rest
  _: _
  path: path
  cjson: cjson
  crypto: crypto
  df: df
  exec: exec
  spawn: spawn
  helenus: helenus
  redis: redis
  #hdfs: hdfs
  solr: solr
  cloudwatch: new cloudwatchApi.AmazonCloudwatchClient()
  bold: '\x1B[0;1m'
  red: '\x1B[0;31m'
  green: '\x1B[0;32m'
  reset: '\x1B[0m'
  messages:
    'PLUGINS_LOADED': 'Plugins loaded, node-monitor running.'
    'FOUND_PLUGIN_CONFIG': 'Found plugin config.'
    'PLUGIN_STOPPED': 'Plugin stopped.'
  errors: 
    'NOT_CONFIGURED_CORRECTLY': 'Not configured correctly.'
    'NOTIFICATION_EMAIL_NOT_SENT': 'E-mail not sent.'
    'NOTIFICATION_SMS_NOT_SENT': 'SMS not sent.'
    'NO_PLUGIN_CONFIG': 'No plugin config found.'
    'PLUGIN_LOAD_ERROR': 'Error (re)loading plugin.'

  log: (message, color, explanation) ->

    ### Log with an explanation in a specified color. ###

    # TODO if log...

    console.log @reset + (color or '') + message + ' ' + (explanation or '')
    console.log @reset

  err: (message) ->

    ### Throw a fatal exception. ###

    throw new Error(@reset + @red + message)

  formatLogMessage: (type, message) ->

    ### Standard internal log message for filesystems. ###

    epoch = new Date().getTime()

    log = epoch + ' ' + type + ' ' + message
    log = log.toString().replace /\r\n|\r/g, '\n'
    log = log + '\n'

    log

  formatLog: (type, message) ->

    ### Standard internal log message for dbs. ###

    now = new Date()

    log =
      key: df(now, 'yy:m:dd')
      epoch: now.getTime()
      message: type + ' ' + message

    log

  responseHandler: (result, resp, cb) ->

    ### Handle server-side errors / generic responses. ###

    if result instanceof Error
      data =
        status: 500
        body: result
      if cb
        cb data
    else
      data = 
        status: resp.statusCode
        body: result
      if cb
        cb data

  post: (username, password, url, postParams, cb) ->

    ### HTTP POST. ###

    @rest.post(url,
      username: username
      password: password
      data: postParams
    ).on 'complete', (result, resp) =>
      @responseHandler result, resp, cb

  get: (username, password, url, cb) ->

    ### HTTP GET. ###

    @rest.get(url,
      username: username
      password: password
    ).on 'complete', (result, resp) =>
      @responseHandler result, resp, cb

  del: (username, password, url, delParams, cb) ->

    ### HTTP DELETE. ###

    @rest.del(url,
      username: username
      password: password
      data: delParams
    ).on 'complete', (result, resp) =>
      @responseHandler result, resp, cb

  info: () ->

    ### Return process info. ###

    info = 
      version: process.version
      platform: process.platform
      arch: process.arch

    info

  cmd: (command, cb) ->

    ### Run a unix command. ###

    child = @exec(command, (error, stdout, stderr) ->
      cb new String(stdout).trim(), pid
    )    

  isEmpty: (variable) ->

    ### Check for empty. ###
    
    if variable is 'none' or variable is '' or typeof variable is 'undefined' or variable is null
      return true
    else
      return false

  md5: (text) ->

    ### MD5 a string. ###

    @crypto.createHash('md5').update(text).digest('hex')

  getGlobalConfig: () ->

    ### Return JSON config from process. ###

    JSON.parse(process.env.config)

  filterCoffeeSuffix: (file) ->

    ### Filter coffee suffix from file. ###

    file.substr(0, file.length - 7)

  

module.exports = Base
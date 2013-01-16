require 'flour'
fs = require 'fs'
{spawn, exec} = require 'child_process'
shelljs = require 'shelljs'

process.setMaxListeners(0)

Function::trace = do () =>
  makeTracing = (ctorName, fnName, fn) =>
    (args...) ->
      console.log "TRACE #{ctorName}:#{fnName}"
      fn.apply @, args
  (arg) ->
    for own name, fn of arg 
      @prototype[name] = makeTracing @name, name, fn

class Test

  bold: '\x1B[0;1m'
  red: '\x1B[0;31m'
  green: '\x1B[0;32m'
  reset: '\x1B[0m'

  log: (message, color) ->

    ### Log all messages with ability for color encoding. ###

    if !color
      color = @green

    console.log @reset + color + message
    console.log @reset

  run: (cmd, options) ->

    ### Spawn processes. ###

    @log 'run: ' + cmd, @green
    @log 'w/ options: ' + options, @green

    aprocess = spawn cmd, options
    aprocess.stdout.pipe process.stdout
    #aprocess.stdout.pipe process.stderr

  lint: (file) ->

    ### Check syntax. ###

    @run './node_modules/coffeelint/bin/coffeelint', ['-f', __dirname + '/conf/lint.json', file]

  mocha: (file) ->

    ### Run tests on a file on its counterpart. ###

    tests = file.replace('src', 'test')

    @run './node_modules/mocha/bin/mocha', ['--compilers', 'coffee:coffee-script', tests, '--require', 'should', '-R', 'spec', '-t', 20 * 1000]
        
  walk: (dir, cb) ->

    ### Walk a directory, return files. ###

    results = []
    fs.readdir dir, (err, list) =>
      return done(err)  if err
      pending = list.length
      return done(null, results)  unless pending
      list.forEach (file) =>
        file = dir + '/' + file
        fs.stat file, (err, stat) =>
          if stat and stat.isDirectory()
            @walk file, (err, res) =>
              results = results.concat(res)
              cb null, results  unless --pending
          else
            results.push file
            cb null, results  unless --pending

test = new Test()    

### Start tests. ###

task 'watch', 'Compile/test assets on-the-fly with watch, run tests.', ->

  watch 'src', (file) -> 
    invoke 'recipe'
    test.lint file
    test.mocha file

task 'good', 'Check javascript syntax with lint.', ->

  test.walk __dirname + '/src', (err, files) ->
    if files isnt null and !err
      files = files.filter (file) ->
        file.substr(-7) is '.coffee'
      for file in files
        test.lint file
    else
      test.log 'No files to lint!', test.green

task 'recipe', 'Generate documentation with coffedoc.', ->

  test.run './node_modules/coffeedoc/bin/coffeedoc', ['-o','docs', '--stdout', 'false', 'src']
  
task 'tests', 'Run tests.', () ->

  test.walk __dirname + '/src', (err, files) ->
    if files isnt null and !err
      files = files.filter (file) ->
        file.substr(-7) is '.coffee'
      for file in files
        test.mocha file
    else
      test.log 'No tests!', test.green

option '-f', '--file [MOCHA_TEST_FILE]', 'Set a single test file when invoking `test`'
task 'test', 'Run a test for a single file.', (options) ->

  if options.file
    test.mocha options.file
  else
    test.log 'No file specified!', test.red
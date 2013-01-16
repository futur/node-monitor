{EventEmitter} = require 'events'

class Base extends EventEmitter
  
class App extends Base

  constructor: (cb) ->

    console.log 'setup'

    @on 'listener:1', (data) ->
      console.log 'listener 1: ' + data

    @on 'listener:2', (data) ->
      console.log 'listener 2: ' + data

    cb()

class One extends Base

  fire: () ->

    console.log 'fire 1'

    @emit 'listener:1', 1

class Two extends Base

  fire: () ->

    console.log 'fire 2'

    @emit 'listener:2', 2

new App(
  () ->
    setTimeout (->
      one = new One()
      one.fire()
      setTimeout (->
        two = new Two()
        two.fire()
      ), 2000
    ), 2000
)
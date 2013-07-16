{exec} = require 'child_process'

task 'tests', 'run tests', ->
    command  = "mocha tests/server.coffee "
    command += "--compilers coffee:coffee-script --colors"
    exec command, (err, stdout, stderr) ->
      console.log err
      console.log stdout
      console.log stderr

task 'build', 'build src into lib', ->
    exec "coffee --output lib --compile src"
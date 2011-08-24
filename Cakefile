{exec} = require 'child_process'
task 'build', 'Build project from src/coffee/*.coffee to build/*.js', ->
  exec 'coffee --compile --output build src/coffee', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr
  exec 'coffee --compile --output build src/coffee', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr

task 'minify', 'Minify the resulting application file after build', ->
  exec 'uglifyjs -o build/placeholder.min.js build/placeholder.js', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr
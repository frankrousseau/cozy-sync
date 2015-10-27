{exec} = require 'child_process'
fs     = require 'fs'
logger = require('printit')
            date: false
            prefix: 'cake'

option '-f', '--file [FILE*]' , 'List of test files to run'
option '-d', '--dir [DIR*]' , 'Directory of test files to run'
option '-e' , '--env [ENV]', 'Run tests with NODE_ENV=ENV. Default is test'
option '' , '--use-js', 'If enabled, tests will run with the built files'

options =  # defaults, will be overwritten by command line options
    file        : no
    dir         : no

# Grab test files of a directory recursively
walk = (dir, excludeElements = []) ->
    fileList = []
    list = fs.readdirSync dir
    if list
        for file in list
            if file and file not in excludeElements
                filename = "#{dir}/#{file}"
                stat = fs.statSync filename
                if stat and stat.isDirectory()
                    fileList2 = walk filename, excludeElements
                    fileList = fileList.concat fileList2
                else if filename.substr(-6) is "coffee"
                    fileList.push filename
    return fileList

taskDetails = '(default: ./tests, use -f or -d to specify files and directory)'
task 'tests', "Run tests #{taskDetails}", (opts) ->
    logger.options.prefix = 'cake:tests'
    files = []
    options = opts

    if options.dir
        dirList   = options.dir
        files = walk(dir, files) for dir in dirList
    if options.file
        files  = files.concat options.file
    unless options.dir or options.file
        files = walk "tests"

    env = if options['env'] then "NODE_ENV=#{options.env}" else "NODE_ENV=test"
    env += " USE_JS=true" if options['use-js']? and options['use-js']
    logger.info "Running tests with #{env}..."
    command = "#{env} mocha " + files.join(" ") + " --reporter spec --colors "
    command += "--compilers coffee:coffee-script/register"
    exec command, (err, stdout, stderr) ->
        console.log stdout
        if err
            console.log stderr
            logger.error "Running mocha caught exception:\n" + err
            setTimeout (=> process.exit 1), 10
        else
            logger.info "Tests succeeded!"
            setTimeout (=> process.exit 0), 10

buildJade = ->
    jade = require 'jade'
    for file in fs.readdirSync './server/views/'
        filename = "./server/views/#{file}"
        template = fs.readFileSync filename, 'utf8'
        output = """
        var jade = require('jade/runtime');\n
        module.exports = #{jade.compileClient template, {filename}}
        """
        name = file.replace '.jade', '.js'
        fs.writeFileSync "./build/server/views/#{name}", output

buildJsInLocales = ->
    path = require 'path'
    # server files
    for file in fs.readdirSync './server/locales/'
        filename = './server/locales/' + file
        template = fs.readFileSync filename, 'utf8'
        exported = "module.exports = #{template};\n"
        name     = file.replace '.json', '.js'
        fs.writeFileSync "./build/server/locales/#{name}", exported
    exec "rm -rf build/server/locales/*.json"


task 'build', 'Build CoffeeScript to Javascript', ->
    logger.options.prefix = 'cake:build'
    logger.info "Start compilation..."
    command = "coffee -cb --output build/server server && " + \
              "coffee -cb --output build/ server.coffee && " + \
              "cp -rf server/locales build/server &&" + \
              "rm -rf build/server/views && " + \
              "mkdir build/server/views"
    exec command, (err, stdout, stderr) ->
        if err
            console.log stderr
            logger.error "An error has occurred while compiling:\n" + err
            process.exit 1
        else
            buildJade()
            buildJsInLocales()
            logger.info "Compilation succeeded."
            process.exit 0


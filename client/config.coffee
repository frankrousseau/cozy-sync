path = require 'path'
exports.config =

    files:
        javascripts:
            joinTo:
                'javascripts/app.js': /^app/
                'javascripts/vendor.js': /^vendor/
            order:
                # Files in `vendor` directories are compiled before other files
                # even if they aren't specified in order.
                before: [
                    'vendor/scripts/jquery-2.1.1.js'
                    'vendor/scripts/superagent.js'
                    'vendor/scripts/react-with-addons.js'
                    'vendor/scripts/polyglot.js'
                    'vendor/scripts/spin.js'
                    'vendor/scripts/react-loader.js'
                ]

        stylesheets:
            joinTo: 'stylesheets/app.css'

        templates:
            defaultExtension: 'jade'
            joinTo: 'javascripts/app.js'

    plugins:

        cleancss:
            keepSpecialComments: 0
            removeEmpty: true

        digest:
            referenceFiles: /\.jade$/

    overrides:
        production:
            # re-enable when uglifyjs will handle properly in source maps
            # with sourcesContent attribute
            #optimize: true
            sourceMaps: true
            paths:
                public: path.resolve __dirname, '../build/client/public'

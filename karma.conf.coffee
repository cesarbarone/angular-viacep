module.exports = (config) ->
  config.set
    # base path, that will be used to resolve files and exclude
    # basePath: ''

    # testing framework to use (jasmine/mocha/qunit/...)
    frameworks: ['jasmine']

    reporters: ['mocha']

    mochaReporter:
      output: 'autowatch'

    preprocessors:
      '**/*.coffee'        : ['coffee']

    coffeePreprocessor:
      options:
        bare: true
        sourceMap: true
      transformPath: (path) ->
        path.replace /\.coffee$/, '.js'

    jsonFixturesPreprocessor:
      variableName: '__json__'

    # list of files / patterns to load in the browser
    files: [
      'bower_components/angular/angular.js'
      'bower_components/angular-mocks/angular-mocks.js'
      'src/angular-viacep.coffee'
      'test/angular-viacep.spec.coffee'
    ]

    ngHtml2JsPreprocessor:
      stripPrefix: 'src/'
      # moduleName: 'template'


    # list of files / patterns to exclude
    exclude: []

    # web server port
    # port: 8080

    # level of logging
    # possible values: LOG_DISABLE || LOG_ERROR || LOG_WARN || LOG_INFO || LOG_DEBUG
    logLevel: config.LOG_INFO

    # Start these browsers, currently available:
    # - Chrome
    # - ChromeCanary
    # - Opera
    # - Safari (only Mac)
    # - PhantomJS
    # - IE (only Windows)
    browsers: [
      # 'PhantomJS'
      'Chrome'
      # 'Firefox'
    ]

    # Continuous Integration mode
    # if true, it capture browsers, run tests and exit
    singleRun: false

    # Which plugins to enable
    plugins: [
      'karma-chrome-launcher'
      'karma-phantomjs-launcher'
      'karma-jasmine'
      'karma-mocha-reporter'
      'karma-coffee-preprocessor'
      'karma-coverage'
    ]

    # enable / disable watching file and executing tests whenever any file changes
    autoWatch: true

    colors: true

    # Uncomment the following lines if you are using grunt's server to run the tests
    # proxies: '/base/': 'http://localhost:8080/'
    # URL root prevent conflicts with the site root
    # urlRoot: '_karma_'

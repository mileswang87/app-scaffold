del = require "del"
path = require "path"
wiredep = require("wiredep").stream


module.exports = (gulp, plugins, cfg) ->
  $$ = plugins
  log = $$.util.log
  webpack = $$.webpackBuild
  batch = (fn) ->
    $$.batch fn, (err) ->
      log $$.util.colors.red("Err: "), err.message

  gulp.task "dev:clean", (cb) ->
    del(['tmp'], () ->
      cb()
    )

  gulp.task "watch:scss", (cb) ->
    $$.watch cfg.scss.source,
      base: cfg.scss.base
      verbose: true
      ignoreInitial: false
    , batch(() ->
        gulp.src cfg.scss.source
        .pipe $$.sourcemaps.init()
        .pipe $$.sass
          errLogToConsole: true
        .pipe $$.autoprefixer()
        .pipe $$.concat('app.css')
        .pipe $$.sourcemaps.write './',
          sourceRoot: "/scss/"
        .pipe gulp.dest(cfg.scss.tmp)
        .on 'end', () ->
          if cb
            cb()
            cb = null
      )

  gulp.task "watch:webpack", (cb) ->
    $$.watch 'client/app/**/*',
      ignoreInitial: false
    , (event) ->
      gulp.src event.path
      .pipe webpack.closest('webpack.config.js')
      .pipe webpack.init(cfg.webpackBuildConfig)
      .pipe webpack.props(cfg.webpackDevOptions)
      .pipe webpack.watch (err, stats) ->
        gulp.src @path
        .pipe webpack.proxy(err, stats)
        .pipe webpack.format
          verbose: true
          version: false
        .pipe gulp.dest('./tmp/app')
        .on 'end', () ->
          if cb
            cb()
            cb = null

  gulp.task 'wiredep', () ->
    gulp.src './client/index.html'
    .pipe wiredep(
      ignorePath: "../bower_components/"
    )
    .pipe gulp.dest('./client')

  gulp.task 'inject',[
    'watch:scss'
    'watch:webpack'
    'wiredep'
  ], () ->
    appSrc = gulp.src [
      './tmp/**/*.js'
      './tmp/**/*.css'
    ], {read: false}
    vendorSrc = gulp.src [
      './vendor/**/*.js'
      './vendor/**/*.css'
    ]
    gulp.src './client/index.html'
    .pipe $$.inject(vendorSrc,
      starttag: '<!-- inject:lib:{{ext}} -->'
      addRootSlash: false
      ignorePath: ["vendor"])
    .pipe $$.inject(appSrc,
      addRootSlash: false
      ignorePath: ["client/","tmp/"])
    .pipe gulp.dest("./client")

  gulp.task 'develop', ['inject'], () ->
    $$.nodemon
      script: './server/bin/www'
      watch: ['server/']
      ext: 'js json'
      env: { 'NODE_ENV': 'development' }
    .on 'start', () ->
      log($$.util.colors.green('Server start successful'));

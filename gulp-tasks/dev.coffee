del = require "del"
path = require "path"
wiredep = require("wiredep").stream

###
  TODO
  1. watch SCSS => sass() => concat() =>
  2. watch coffee => webpack =>
###
scss =
  source: './client/scss/**/*.scss'
  base: './client/scss'
  tmp: './tmp/assets/stylesheets'

webpackOptions =
  debug: true
  devtool: "#source-map"
  watchDelay: 200
webpackConfig =
  useMemoryFs: true
  progress: true

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
    $$.watch scss.source,
      base: scss.base
      verbose: true
      ignoreInitial: false
    , batch(() ->
        gulp.src scss.source
        .pipe $$.sourcemaps.init()
        .pipe $$.sass
          errLogToConsole: true
        .pipe $$.autoprefixer()
        .pipe $$.concat('main.css')
        .pipe $$.sourcemaps.write './',
          sourceRoot: "/scss/"
        .pipe gulp.dest(scss.tmp)
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
      .pipe webpack.init(webpackConfig)
      .pipe webpack.props(webpackOptions)
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
    ###
  TODO
###
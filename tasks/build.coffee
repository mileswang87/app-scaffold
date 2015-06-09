del = require "del"
wiredep = require("wiredep").stream


module.exports = (gulp, plugins, cfg) ->
  $$ = plugins
  log = $$.util.log
  webpack = $$.webpackBuild

  gulp.task "clean",  (cb) ->
    del ['tmp'
         'build/**/*'
         '!build/.elasticbeanstalk'
         '!build/.ebextensions'
         '!build/.gitignore'
         '!build/.git'
    ], () ->
      cb()

  gulp.task "build:base", () ->
    gulp.src ['client/index.html'],
      base: "./"
    .pipe gulp.dest('build/')

  gulp.task "build:scss", ["build:base"], () ->
    gulp.src cfg.scss.source
    .pipe $$.sass()
    .pipe $$.autoprefixer()
    .pipe gulp.dest(cfg.scss.tmp)

  gulp.task "build:webpack", () ->
    gulp.src "webpack.config.js"
    .pipe webpack.init(cfg.webpackBuildConfig)
    .pipe webpack.props(cfg.webpackProdOption)
    .pipe webpack.run()
    .pipe webpack.format
      version: false
      timings: true
    .pipe webpack.failAfter
      errors: true,
      warnings: false
    .pipe(gulp.dest('./tmp/app'))

  gulp.task "build:inject", [
    'build:base'
    'build:scss'
    'build:webpack'
  ] ,() ->
    appSrc = gulp.src [
      './tmp/**/*.js'
      './tmp/**/*.css'
    ], {read: false}
    vendorSrc = gulp.src [
      './vendor/**/*.js'
      './vendor/**/*.css'
    ]
    gulp.src './build/client/index.html'
    .pipe $$.inject vendorSrc,
      starttag: '<!-- inject:lib:{{ext}} -->'
      relative: true
    .pipe $$.inject appSrc,
      relative: true
    .pipe gulp.dest("./build/client")

  gulp.task "build:wiredep", [
    "build:base"
    "build:inject"
  ], () ->
    gulp.src('./build/client/index.html')
    .pipe wiredep()
    .pipe gulp.dest('./build/client')

  gulp.task "build:usemin", [
    'build:base'
    'build:wiredep'
  ], () ->
    gulp.src './build/client/index.html'
    .pipe $$.usemin()
#        libcss: [$$.minifyCss(),$$.rev()]
#        maincss: [$$.minifyCss(),$$.rev()]
#        libjs: [$$.uglify(),$$.rev()]
#        appjs: [$$.uglify(),$$.rev()]
#    .on "error", log
    .pipe gulp.dest('./build/client')

  gulp.task 'build:copy', [ 'build:base' ], ->
    gulp.src([
      'server/**'
      'client/app/**/*.html'
      'client/assets/**'
      'package.json'
    ], base: './')
    .pipe gulp.dest('build/')

  gulp.task 'build', [
    'build:base'
    'build:wiredep'
    'build:inject'
    'build:usemin'
    'build:copy'
  ], (cb) ->
    del [ 'tmp' ], ->
      cb()



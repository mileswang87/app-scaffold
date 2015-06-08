/**
 * Created by wangxunn on 4/10/15.
 */
require('coffee-script/register');
var gulp = require('gulp');
var plugins = require('gulp-load-plugins')();

var cfg = {
  scss: {
    source: './client/scss/**/*.scss',
    base: './client/scss',
    tmp: './tmp/assets/stylesheets'
  },
  webpackDevOptions: {
    debug: true,
    devtool: "#source-map",
    watchDelay: 200
  },
  webpackBuildConfig: {
    useMemoryFs: true,
    progress: true
  }
};

require('./tasks/dev')(gulp, plugins, cfg);

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
  webpackProdOption: {
    output: {
      filename: "app.js"
    },
    plugins: [
      new plugins.webpackBuild.core.DefinePlugin({
        "process.env": {
          "NODE_ENV": JSON.stringify("production")
        }
      }),
      new plugins.webpackBuild.core.optimize.DedupePlugin(),
      new plugins.webpackBuild.core.optimize.UglifyJsPlugin()
    ]
  },
  webpackBuildConfig: {
    useMemoryFs: true,
    progress: true
  }
};

require('./tasks/dev')(gulp, plugins, cfg);
require('./tasks/build')(gulp, plugins, cfg);

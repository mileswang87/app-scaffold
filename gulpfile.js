/**
 * Created by wangxunn on 4/10/15.
 */
require('coffee-script/register');
var gulp = require('gulp');
var plugins = require('gulp-load-plugins')();

var cfg = {};

require('./gulp-tasks/dev')(gulp, plugins, cfg);
//require('./gulp-tasks/build')(gulp, plugins, cfg);
//require('./gulp-tasks/webpack')(gulp, plugins, cfg);
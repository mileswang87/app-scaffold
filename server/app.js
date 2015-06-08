var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');

var app = express();
var env = process.env.NODE_ENV || 'development';
var api = require("./api");
var fs = require("fs");

var logStream = function() {
  var logDir = path.resolve(__dirname, "../log");
  if (!fs.existsSync(logDir)) {
    fs.mkdirSync(logDir);
  }
  return fs.createWriteStream(path.resolve(logDir, './access.log'), {flags:"a"});
}();

// view engine setup
//app.set('views', path.join(__dirname, 'views'));
//app.set('view engine', 'jade');

// uncomment after placing your favicon in /public
//app.use(favicon(__dirname + '/public/favicon.ico'));
app.use(logger('dev', {stream: logStream}));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.resolve(__dirname, '../client/')));

if (env === 'development') {
  app.use(express.static(path.resolve(__dirname, '../tmp/')));
  app.use(express.static(path.resolve(__dirname, '../vendor/')));
  app.use(express.static(path.resolve(__dirname, '../bower_components/')));
}
// throw 404 for missing partials or assets
app.use(/\/app|\/assets/, function(req, res){
  res.status(404).send('Sorry, we cannot find that!');
});

// api routing
app.use('/api/', api);

app.use("*", function(req, res){
  res.sendFile('index.html', {root: './client'})
});


module.exports = app;


var angular = require("angularjs");
require('angular-ui-router');
var app = angular.module("applicationName", ['ui.router']);

/* require sub modules */
require("./core/entry")(app);
require("./home/entry")(app);

var angular = require("angularjs");
var app = angular.module("applicationName", ['ui.router']);


/* require sub modules */
require("./core/entry")(app);
require("./home/entry")(app);
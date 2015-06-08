var RouteConfiguration = function ($locationProvider, $stateProvider, $urlRouterProvider) {
  $locationProvider.html5Mode(true)
  $stateProvider.state("home", {
    url: '/',
    templateUrl: "app/home/home.html",
    controller: "HomeController",
    controllerAs: "vm"
  });
  $urlRouterProvider.otherwise("/")
};

RouteConfiguration.$inject = [
  "$locationProvider",
  "$stateProvider",
  "$urlRouterProvider"
];

module.exports = RouteConfiguration;
var HomeController = function($example) {
  this.name = $example.name;
  this.getPrefix = function(){
    return $example.getPrefix();
  }
};
HomeController.$inject = [
  "module.namespace.example"
];

module.exports = HomeController;

module.exports = function(app){
  /* require services */
  app.service({
    "module.namespace.example": require("./services/example.service")
  });
  /* require configuration*/
  app.config(require('./route.config'));
};
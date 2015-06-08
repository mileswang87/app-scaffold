/**
 * Created by wangxunn on 6/8/15.
 */

var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  res.json({
    content: "hello world"
  })
});

/* throw 404 error*/
router.use(function(req, res){
  res.status(404).json({
    "error":"No such api"
  })
});

module.exports = router;
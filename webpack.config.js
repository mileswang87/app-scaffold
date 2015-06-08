/**
 * Created by wangxunn on 4/30/15.
 */
var webpack = require('webpack');
var path = require('path');

module.exports = {
  context: __dirname + "/client/app",
  entry: "./entry.coffee",
  output: {
    path: __dirname,
    filename: "app.js"
  },
  plugins: [
    new webpack.DefinePlugin({
      ON_TEST: process.env.NODE_ENV === 'test'
    })
  ],
  externals: {
    angularjs: "angular"
  },
  module: {
    loaders: [
      { test: /\.coffee$/, loader: "coffee" },
      { test: /\.html/, loader: "html?attrs=false" },
      { test: /\.yaml/, loader: "json!yaml" }
    ]
  }
};

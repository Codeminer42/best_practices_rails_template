const path = require('path')
const config = require('./webpack.config')

config.devServer = {
  host: 'localhost',
  port: '8081'
};

const index = path.resolve(__dirname, '../spec/javascripts/index.browser.js');

config.entry = {
  test: [`mocha!${index}`]
};

config.output.publicPath = 'http://localhost:8081/'

module.exports = config

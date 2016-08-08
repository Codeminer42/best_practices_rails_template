const path = require('path');

const webpack = require('karma-webpack');
const webpackConfig = require('./webpack.config');

const webpackEntryFile = '../spec/javascripts/index.integration.js'

webpackConfig.entry = {
  test: path.resolve(__dirname, webpackEntryFile)
};

webpackConfig.devtool = 'inline-source-map'

module.exports = function (config) {
  config.set({
    frameworks: ['mocha', 'chai', 'sinon', 'fixture'],

    // avoids running tests twice when on watch mode
    files: [
      {
        pattern: webpackEntryFile,
        watched: false,
        included: true,
        served: true,
      },
    ],

    preprocessors: {
      webpackEntryFile: ['webpack', 'sourcemap', 'coverage'],
    },

    webpack: webpackConfig,

    reporters: ['mocha', 'notify', 'progress', 'coverage'],

    coverageReporter: {
      type: 'lcov',
      dir: 'coverage/',
    },

    plugins: [
      webpack,
      'karma-mocha',
      'karma-chai',
      'karma-chrome-launcher',
      'karma-phantomjs-launcher',
      'karma-spec-reporter',
      'karma-sourcemap-loader',
    ],

    webpackMiddleware: {
      noInfo: true,
    },

    phantomjsLauncher: {
      exitOnResourceError: true,
    },

    mochaReporter: { output: 'minimal' },
    port: 9876,
    colors: true,
    logLevel: config.LOG_INFO,
    autoWatch: false,
    browsers: ['PhantomJS'],
    singleRun: true,
    basePath: '.',
  });
};

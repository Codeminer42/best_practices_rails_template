const path = require('path');
const webpack = require('webpack');
const StatsPlugin = require('stats-webpack-plugin');

const production = process.env.TARGET === 'production';

const config = {
  entry: './app/assets/javascripts/application.js',
  output: {
    // must match config.webpack.output_dir
    path: path.join(__dirname, '..', 'public', 'webpack'),
    publicPath: '/webpack/',

    filename: production ? '[name]-[chunkhash].js' : '[name].js',
  },
  module: {
    loaders: [
      { test: /\.js$/, exclude: /node_modules/, loader: 'babel-loader' },
      { test: /\.json$/, exclude: /node_modules/, loader: 'json-loader' },
    ],
  },
  resolve: {
    root: path.join(__dirname, '..', 'app', 'assets', 'javascripts'),
  },
  plugins: [
    // must match config.webpack.manifest_filename
    new StatsPlugin('manifest.json', {
      chunkModules: false,
      source: false,
      chunks: false,
      modules: false,
      assets: true,
    })],
};

if (production) {
  config.plugins.push(
    new webpack.NoErrorsPlugin(),
    new webpack.optimize.UglifyJsPlugin({
      compressor: { warnings: false },
      sourceMap: false,
    }),
    new webpack.DefinePlugin({
      'process.env': { NODE_ENV: JSON.stringify('production') },
    }),
    new webpack.optimize.DedupePlugin(),
    new webpack.optimize.OccurenceOrderPlugin()
  );
} else {
  config.devServer = {
    port: 3808,
    headers: { 'Access-Control-Allow-Origin': '*' },
  };

  config.output.publicPath = '//localhost:3808/webpack/',
  // Source maps
  config.devtool = 'cheap-module-eval-source-map'
}

module.exports = config;

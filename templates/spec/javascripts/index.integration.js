const context = require.context('.', true, /integration\/.+\.spec\.js$/);

context.keys().forEach(context);

module.exports = context;

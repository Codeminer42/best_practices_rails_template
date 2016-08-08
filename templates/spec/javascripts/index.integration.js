const integrationSpecs = require.context('.', true, /integration\/.+\.spec\.js$/);

integrationSpecs.keys().forEach(integrationSpecs);

module.exports = integrationSpecs;

const unitSpecs = require.context('.', true, /.+\.spec\.js$/)

unitSpecs.keys().forEach(unitSpecs)

module.exports = unitSpecs

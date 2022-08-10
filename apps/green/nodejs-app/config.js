'use strict'

const { from } = require('env-var')
const assert = require('assert')

module.exports = (variables) => {
  assert(variables, 'process environment variables must be passed to the config module')

  const { get } = from(variables)

  return {
    HTTP_PORT: get('HTTP_PORT').default(8080).asPortNumber()
  }
}
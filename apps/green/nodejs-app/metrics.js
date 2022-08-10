'use strict'

/**
 * Configures the prometheus client and configures a function that
 * will return default metrics for the Node.js process.
 * @returns {Function<Promise<string>>}
 */
module.exports = () => {
  const prometheus = require('prom-client');
  const { collectDefaultMetrics, Registry } = prometheus;

  const register = new Registry();
  collectDefaultMetrics({ register })

  return () => register.metrics()
}
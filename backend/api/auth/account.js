const express = require('express');
const router = express.Router();

// Account API endpoint
router.get('/', (req, res) => {
  const headers = req.headers;
  
  // Filter JWT-related headers
  const jwtHeaders = {};
  Object.keys(headers).forEach(key => {
    if (key.startsWith('X-User-') || key.startsWith('X-JWT-') || key.startsWith('X-App-')) {
      jwtHeaders[key] = headers[key];
    }
  });

  const response = {
    message: 'Account API - Kong JWT Headers Test',
    timestamp: new Date().toISOString(),
    jwt_headers_injected: jwtHeaders,
    all_headers: headers,
    test_status: Object.keys(jwtHeaders).length > 0 ? 'SUCCESS - Headers injected!' : 'FAILED - No headers injected',
  };

  res.json(response);
});

module.exports = router;

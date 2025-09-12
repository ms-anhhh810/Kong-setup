const express = require('express');
const accountRouter = require('./api/auth/account');
const app = express();
const port = 3000;

// Middleware to parse JSON
app.use(express.json());

// Root endpoint
app.get('/', (req, res) => {
  const headers = req.headers;
  
  // Filter JWT-related headers
  const jwtHeaders = {};
  Object.keys(headers).forEach(key => {
    if (key.startsWith('X-User-') || key.startsWith('X-JWT-') || key.startsWith('X-App-')) {
      jwtHeaders[key] = headers[key];
    }
  });

  const response = {
    message: 'Backend Test API - Kong JWT Headers Test',
    timestamp: new Date().toISOString(),
    jwt_headers_injected: jwtHeaders,
    all_headers: headers,
    test_status: Object.keys(jwtHeaders).length > 0 ? 'SUCCESS - Headers injected!' : 'FAILED - No headers injected',
    kong_headers: {
      'X-Kong-Request-Id': headers['x-kong-request-id'] || 'Not found',
      'X-Kong-Upstream-Latency': headers['x-kong-upstream-latency'] || 'Not found',
      'X-Kong-Proxy-Latency': headers['x-kong-proxy-latency'] || 'Not found'
    }
  };

  res.json(response);
});

// Use account router
app.use('/api/auth/account', accountRouter);

app.listen(port, '0.0.0.0', () => {
  console.log(`Backend server running at http://0.0.0.0:${port}`);
});

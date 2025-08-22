const http = require('http');
const { spawn } = require('child_process');

// Simple HTTP wrapper for MCP servers that don't support HTTP natively
const server = http.createServer((req, res) => {
    res.setHeader('Content-Type', 'application/json');
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

    if (req.method === 'OPTIONS') {
        res.writeHead(200);
        res.end();
        return;
    }

    if (req.url === '/health') {
        res.writeHead(200);
        res.end(JSON.stringify({ status: 'healthy', service: 'MCP HTTP Wrapper' }));
        return;
    }

    if (req.url === '/mcp') {
        res.writeHead(200);
        res.end(JSON.stringify({ 
            message: 'MCP HTTP Wrapper',
            endpoints: ['/health', '/mcp'],
            note: 'This is a wrapper for MCP servers that use stdio transport'
        }));
        return;
    }

    res.writeHead(404);
    res.end(JSON.stringify({ error: 'Not found' }));
});

const port = process.env.PORT || 8082;
server.listen(port, () => {
    console.log(`MCP HTTP Wrapper listening on port ${port}`);
});

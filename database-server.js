const http = require('http');

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
        res.end(JSON.stringify({ status: 'healthy', service: 'Database MCP HTTP Wrapper' }));
        return;
    }

    if (req.url === '/mcp') {
        res.writeHead(200);
        res.end(JSON.stringify({ 
            message: 'Database MCP HTTP Wrapper',
            endpoints: ['/health', '/mcp'],
            note: 'Database MCP available via stdio transport'
        }));
        return;
    }

    res.writeHead(404);
    res.end(JSON.stringify({ error: 'Not found' }));
});

const port = 8083;
server.listen(port, () => {
    console.log(`Database MCP HTTP Wrapper listening on port ${port}`);
});

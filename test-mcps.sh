#!/bin/bash

echo "🧪 Testing 3AmigosMCP Container"
echo "================================"

# Check if container is running
echo "📦 Checking container status..."
if docker ps | grep -q "3AmigosMCP"; then
    echo "✅ Container is running"
else
    echo "❌ Container is not running"
    exit 1
fi

# Check container health
echo "🏥 Checking container health..."
HEALTH_STATUS=$(docker inspect --format='{{.State.Health.Status}}' 3AmigosMCP)
if [ "$HEALTH_STATUS" = "healthy" ]; then
    echo "✅ Container is healthy"
else
    echo "❌ Container health status: $HEALTH_STATUS"
    exit 1
fi

# Test Playwright MCP
echo "🎭 Testing Playwright MCP..."
if docker exec 3AmigosMCP npx @playwright/mcp@latest --help &> /dev/null; then
    echo "✅ Playwright MCP is working"
else
    echo "❌ Playwright MCP failed"
    exit 1
fi

# Test Filesystem MCP
echo "📁 Testing Filesystem MCP..."
if timeout 5s docker exec 3AmigosMCP npx @modelcontextprotocol/server-filesystem /workspace &> /dev/null; then
    echo "✅ Filesystem MCP is working"
else
    echo "❌ Filesystem MCP failed"
    exit 1
fi

# Test Database MCP
echo "🗄️ Testing Database MCP..."
if timeout 5s docker exec 3AmigosMCP npx @ahmetbarut/mcp-database-server &> /dev/null; then
    echo "✅ Database MCP is working"
else
    echo "❌ Database MCP failed"
    exit 1
fi

echo ""
echo "🎉 All tests passed! 3AmigosMCP is ready to use!"
echo ""
echo "📋 Container Information:"
echo "   Container Name: 3AmigosMCP"
echo "   Status: $(docker inspect --format='{{.State.Status}}' 3AmigosMCP)"
echo "   Health: $(docker inspect --format='{{.State.Health.Status}}' 3AmigosMCP)"
echo "   Ports: 8091:8081 (Playwright), 8092:8082 (Filesystem), 8093:8083 (Database)"
echo ""
echo "🔧 To use with Cursor/VS Code, copy the configuration from cursor-mcp-config.json"

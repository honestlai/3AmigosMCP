#!/bin/bash

# Health check for 3AmigosMCP container
# Checks if the container is running and MCP servers are accessible

# Check if container is running
if ! pgrep -f "/start-mcps.sh" > /dev/null; then
    echo "Container process not running"
    exit 1
fi

# Check if Node.js is available
if ! command -v node &> /dev/null; then
    echo "Node.js not found"
    exit 1
fi

# Check if npm is available
if ! command -v npm &> /dev/null; then
    echo "npm not found"
    exit 1
fi

# Check if HTTP-based MCP servers are running on their ports
if ! curl -s http://localhost:8081 > /dev/null; then
    echo "Playwright MCP not responding on port 8081"
    exit 1
fi

# Note: Database MCP server needs additional configuration to run as a service
# For now, we'll skip the database server health check
# if ! curl -s http://localhost:8083 > /dev/null; then
#     echo "Database MCP not responding on port 8083"
#     exit 1
# fi

# Check if Filesystem MCP package is available (stdio-only)
if ! npx @modelcontextprotocol/server-filesystem /workspace &> /dev/null; then
    echo "Filesystem MCP package not available"
    exit 1
fi

# Check if workspace directory exists
if [ ! -d "/workspace" ]; then
    echo "Workspace directory not found"
    exit 1
fi

# Check if data directory exists
if [ ! -d "/data" ]; then
    echo "Data directory not found"
    exit 1
fi

echo "3AmigosMCP container is healthy"
exit 0

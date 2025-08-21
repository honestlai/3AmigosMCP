#!/bin/bash

# Health check for 3AmigosMCP container
# Checks if the container is running and MCP servers are accessible

# Check if container is running
if ! pgrep -f "tail -f /dev/null" > /dev/null; then
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

# Check if MCP packages are installed
if ! npx @playwright/mcp@latest --help &> /dev/null; then
    echo "Playwright MCP not available"
    exit 1
fi

if ! npx @modelcontextprotocol/server-filesystem --help &> /dev/null; then
    echo "Filesystem MCP not available"
    exit 1
fi

if ! npx @modelcontextprotocol/server-sqlite --help &> /dev/null; then
    echo "Database MCP not available"
    exit 1
fi

# Check if workspace directory exists
if [ ! -d "/home/playwright/workspace" ]; then
    echo "Workspace directory not found"
    exit 1
fi

echo "3AmigosMCP container is healthy"
exit 0

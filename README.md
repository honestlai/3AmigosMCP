# 3AmigosMCP

A robust, production-ready Docker container for running multiple MCP (Model Context Protocol) servers with **command-based execution** to eliminate SSH tunnel connection issues.

## Meet the Amigos:
🎭 **Playwright** - The Browser Whisperer
📁 **Filesystem** - The File Wrangler  
🗄️ **Database** - The Data Guardian

## 🎯 **Problem Solved**

**Original Issue**: Cursor/VS Code MCP connections dropping over SSH tunnels, causing red/green bubble cycling.

**Root Cause**: URL-based MCP connections (`"url": "http://localhost:8081/mcp"`) over SSH tunnels create multiple failure points:

* Laptop → SSH tunnel → Cloudflare → server → Docker container → MCP server
* SSE timeouts after 5 minutes of idle time
* Persistent connections that can drop unexpectedly

**Solution**: **Command-based MCP configuration** that executes the MCP servers directly inside the container, eliminating HTTP timeouts and connection state issues.

## 🚀 **Quick Start**

### **1\. Start the Container**

```bash
docker compose up -d
```

### **2\. Verify Container Health**

```bash
docker ps
```

### **3\. Configure Your MCP Client**

Use the command-based configuration below.

## 📋 **MCP Client Configuration**

### **Command-Based Configuration (Recommended)**

**This eliminates SSH tunnel connection issues** by executing MCPs directly in the container:

```json
{
  "mcpServers": {
    "Playwright_MCP": {
      "command": "docker",
      "args": [
        "exec",
        "-i",
        "3amigosmcp",
        "npx",
        "@playwright/mcp@latest",
        "--port",
        "8080",
        "--host",
        "0.0.0.0",
        "--headless",
        "--isolated"
      ],
      "env": {
        "PLAYWRIGHT_BROWSERS_PATH": "/ms-playwright"
      }
    },
    "Filesystem_MCP": {
      "command": "docker",
      "args": [
        "exec",
        "-i",
        "3amigosmcp",
        "npx",
        "@modelcontextprotocol/server-filesystem",
        "/workspace"
      ]
    },
    "Database_MCP": {
      "command": "docker",
      "args": [
        "exec",
        "-i",
        "3amigosmcp",
        "npx",
        "@ahmetbarut/mcp-database-server",
        "--database",
        "/data/data.db"
      ]
    }
  }
}
```

### **Alternative: Enhanced HTTP Configuration**

If you prefer HTTP-based connections (less reliable over SSH):

```json
{
  "mcpServers": {
    "Playwright_MCP": {
      "url": "http://localhost:8091/mcp",
      "retryDelay": 1000,
      "maxRetries": 20,
      "timeout": 60000,
      "backoffMultiplier": 2.0,
      "maxRetryDelay": 15000,
      "connectionTimeout": 15000,
      "keepAlive": true,
      "retryOnTimeout": true,
      "retryOnConnectionError": true
    },
    "Filesystem_MCP": {
      "url": "http://localhost:8092/mcp",
      "retryDelay": 1000,
      "maxRetries": 20,
      "timeout": 60000
    },
    "Database_MCP": {
      "url": "http://localhost:8093/mcp",
      "retryDelay": 1000,
      "maxRetries": 20,
      "timeout": 60000
    }
  }
}
```

## 🔧 **Management Commands**

### **Container Management**

```bash
# Start container
docker compose up -d

# Stop container
docker compose down

# Restart container
docker compose restart

# View logs
docker compose logs -f

# Check status
docker ps
```

### **Health Check**

```bash
# Test MCP endpoints
curl -v http://localhost:8091/mcp
curl -v http://localhost:8092/mcp
curl -v http://localhost:8093/mcp

# Check container health
docker inspect --format='{{.State.Health.Status}}' 3amigosmcp
```

## 🏗️ **Architecture**

### **Command-Based Approach (Recommended)**

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   VS Code       │    │   SSH Tunnel    │    │   Docker        │
│   / Cursor      │───▶│   (Cloudflare)  │───▶│   Container     │
│                 │    │                 │    │                 │
│ Command-based   │    │ No persistent   │    │ Direct MCP      │
│ MCP execution   │    │ connections     │    │ execution       │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### **Why Command-Based Works Better**

* ✅ **No HTTP layer** to timeout
* ✅ **No persistent connections** that can drop
* ✅ **Fresh execution** for each MCP interaction
* ✅ **Direct communication** with container
* ✅ **Eliminates connection state issues**

## 🔍 **Monitoring & Troubleshooting**

### **Check Container Health**

```bash
# Check if container is running
docker ps

# Check container health status
docker inspect --format='{{.State.Health.Status}}' 3amigosmcp

# View container logs
docker logs 3amigosmcp
```

### **Test MCP Connections**

```bash
# Test HTTP endpoints (if using HTTP config)
curl -v http://localhost:8081/mcp
curl -v http://localhost:8082/mcp
curl -v http://localhost:8083/mcp

# Test command-based execution
docker exec -i 3amigosmcp npx @playwright/mcp@latest --help
docker exec -i 3amigosmcp npx @modelcontextprotocol/server-filesystem --help
docker exec -i 3amigosmcp npx @modelcontextprotocol/server-sqlite --help
```

### **Resource Usage**

```bash
# Check resource usage
docker stats 3amigosmcp

# Check memory usage
docker stats --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}"
```

## 🛠️ **Troubleshooting**

### **Common Issues**

#### **1\. Container Not Starting**

```bash
# Check logs for errors
docker compose logs

# Rebuild container
docker compose down
docker compose build --no-cache
docker compose up -d
```

#### **2\. MCP Command Execution Fails**

```bash
# Test commands manually
docker exec -i 3amigosmcp npx @playwright/mcp@latest --help
docker exec -i 3amigosmcp npx @modelcontextprotocol/server-filesystem --help
docker exec -i 3amigosmcp npx @ahmetbarut/mcp-database-server --help

# Check container permissions
docker exec -it 3amigosmcp whoami
```

#### **3\. VS Code/Cursor Can't Connect**

* Verify container is running: `docker ps`
* Check MCP configuration syntax
* Restart VS Code/Cursor after configuration changes
* Ensure Docker is accessible from your SSH session

### **Debugging Commands**

```bash
# Enter container for debugging
docker exec -it 3amigosmcp /bin/bash

# Check MCP processes
docker exec 3amigosmcp ps aux | grep mcp

# Test MCP servers directly
docker exec -i 3amigosmcp npx @playwright/mcp@latest --port 8080 --host 0.0.0.0
docker exec -i 3amigosmcp npx @modelcontextprotocol/server-filesystem /workspace
docker exec -i 3amigosmcp npx @ahmetbarut/mcp-database-server --database /data/data.db
```

## 📊 **Performance & Reliability**

| Feature              | Command-Based | HTTP-Based     |
| -------------------- | ------------- | -------------- |
| **SSH Stability**    | ✅ Excellent   | ⚠️ Problematic |
| **Connection Drops** | ✅ None        | ❌ Frequent     |
| **Timeout Issues**   | ✅ None        | ❌ Common       |
| **Setup Complexity** | ⚠️ Moderate   | ✅ Simple       |
| **Debugging**        | ✅ Easy        | ⚠️ Complex     |

## 🎯 **Getting Started**

1. **Start the container**:  
   ```bash
   docker compose up -d
   ```
2. **Configure your MCP client** using the command-based configuration above
3. **Test the connections**:  
   ```bash
   docker exec -i 3amigosmcp npx @playwright/mcp@latest --help
   docker exec -i 3amigosmcp npx @modelcontextprotocol/server-filesystem --help
   docker exec -i 3amigosmcp npx @ahmetbarut/mcp-database-server --help
   ```
4. **Monitor health**:  
   ```bash
   docker ps  
   docker logs 3amigosmcp
   ```

## 📝 **Configuration Files**

* `docker-compose.yml` - Container orchestration
* `Dockerfile` - Container image definition
* `healthcheck.sh` - Health monitoring script
* `cursor-mcp-config.json` - Example Cursor configuration

## 📚 **Documentation**

* **MCP Client Setup Guide** - Detailed configuration guide
* **Cursor Setup Guide** - VS Code/Cursor specific setup

## 🤝 **Contributing**

Feel free to submit issues and enhancement requests!

## 📄 **License**

This project is open source and available under the MIT License.

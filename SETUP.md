# 3AmigosMCP Setup Guide

## Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/honestlai/3AmigosMCP.git
cd 3AmigosMCP
```

### 2. Start the Container
```bash
docker compose up -d
```

### 3. Verify Everything is Working
```bash
./test-mcps.sh
```

### 4. Configure Your MCP Client

Copy the configuration from `cursor-mcp-config.json` to your Cursor/VS Code MCP settings.

## Container Information

- **Container Name**: `3AmigosMCP`
- **Ports**: 
  - 8091: Playwright MCP
  - 8092: Filesystem MCP  
  - 8093: Database MCP
- **Volumes**:
  - `./workspace` → `/workspace` (Filesystem MCP root)
  - `./data` → `/data` (Database storage)

## Meet the Amigos

🎭 **Playwright** - The Browser Whisperer
- Web automation and browser control
- Supports Chrome, Firefox, WebKit, and Edge
- Headless and headed modes

📁 **Filesystem** - The File Wrangler
- File and directory operations
- Read/write access to workspace
- Secure access control

🗄️ **Database** - The Data Guardian
- Multi-database support (SQLite, PostgreSQL, MySQL)
- Query execution and data management
- Environment-based configuration

## Management Commands

```bash
# Start container
docker compose up -d

# Stop container
docker compose down

# View logs
docker compose logs -f

# Check status
docker ps

# Test all MCPs
./test-mcps.sh
```

## Troubleshooting

### Container Not Starting
```bash
# Check logs
docker compose logs

# Rebuild container
docker compose down
docker compose build --no-cache
docker compose up -d
```

### MCP Connection Issues
- Verify container is running: `docker ps`
- Check health status: `docker inspect --format='{{.State.Health.Status}}' 3AmigosMCP`
- Test individual MCPs using the test script

### Port Conflicts
If ports 8091-8093 are in use, modify `docker-compose.yml` to use different ports.

## Support

For issues and questions, please check the main README.md or create an issue on GitHub.

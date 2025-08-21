FROM mcr.microsoft.com/playwright:v1.40.0-focal

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright

# Install system dependencies and Node.js
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    sqlite3 \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install MCP servers
RUN npm install -g @playwright/mcp@latest \
    @modelcontextprotocol/server-filesystem@latest \
    @ahmetbarut/mcp-database-server@latest

# Create workspace directory
RUN mkdir -p /workspace /data

# Set working directory
WORKDIR /workspace

# Expose ports for MCP servers
EXPOSE 8081 8082 8083

# Health check
COPY healthcheck.sh /healthcheck.sh
RUN chmod +x /healthcheck.sh

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD /healthcheck.sh

# Default command
CMD ["tail", "-f", "/dev/null"]

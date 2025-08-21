FROM mcr.microsoft.com/playwright:v1.40.0-focal

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PLAYWRIGHT_BROWSERS_PATH=/home/playwright/.cache/ms-playwright

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    sqlite3 \
    && rm -rf /var/lib/apt/lists/*

# Switch to playwright user
USER playwright

# Install Node.js and npm
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - \
    && sudo apt-get install -y nodejs

# Install MCP servers
RUN npm install -g @playwright/mcp@latest \
    @modelcontextprotocol/server-filesystem@latest \
    @modelcontextprotocol/server-sqlite@latest

# Create workspace directory
RUN mkdir -p /home/playwright/workspace

# Set working directory
WORKDIR /home/playwright/workspace

# Expose ports for MCP servers
EXPOSE 8081 8082 8083

# Health check
COPY healthcheck.sh /healthcheck.sh
RUN chmod +x /healthcheck.sh

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD /healthcheck.sh

# Default command
CMD ["tail", "-f", "/dev/null"]

FROM node:lts-alpine3.22

# Install necessary packages
RUN apk add --no-cache python3=~3.12 py3-pip git curl bash uv

# Set working directory
WORKDIR /app
RUN mkdir /app/mcp_station
# Clone the mcp_station repository
RUN git clone https://github.com/CocoRoF/mcp_station.git /app/mcp_station

# Change to mcp_station directory
WORKDIR /app/mcp_station

# Sync dependencies and create virtual environment
RUN uv sync

# Create startup script with fallback
RUN echo '#!/bin/bash' > /app/start.sh && \
    echo 'cd /app/mcp_station' >> /app/start.sh && \
    echo 'source .venv/bin/activate' >> /app/start.sh && \
    echo 'python main.py || tail -f /dev/null' >> /app/start.sh && \
    chmod +x /app/start.sh

# Run the application
CMD ["/app/start.sh"]

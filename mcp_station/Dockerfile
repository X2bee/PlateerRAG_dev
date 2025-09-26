# MCP Station Service
FROM node:lts-alpine3.22

# Install Python 3.12 and necessary dependencies
RUN apk add --no-cache python3=~3.12 py3-pip

# Create working directory
WORKDIR /app

# Keep container running
CMD ["tail", "-f", "/dev/null"]
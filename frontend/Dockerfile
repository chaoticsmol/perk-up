# Node.js version
FROM --platform=linux/amd64 node:20-slim AS base

# Set working directory
WORKDIR /app

# Install dependencies
FROM base AS deps

# Copy package files
COPY package.json package-lock.json* ./

# For build dependencies, install all dependencies including dev ones
RUN npm ci

# Build the application
FROM deps AS builder

# Copy source files (node_modules is excluded via .dockerignore)
COPY . .

# Compile client code
RUN npx tsc -p tsconfig.build.json && npx vite build

# Production image
FROM base AS runner

# Set production environment in final stage
ENV NODE_ENV=production

# Install only production dependencies for the final image
COPY package.json package-lock.json* ./
RUN npm ci --omit=dev --no-optional

# Copy built artifacts and server file
COPY --from=builder /app/dist ./dist
COPY server.mjs ./
COPY package.json ./

# Run as non-root user for better security
RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 appuser && \
    chown -R appuser:nodejs /app
USER appuser

# Expose the port the app runs on
EXPOSE 3001

# Set host environment variable to listen on all interfaces
ENV HOST=0.0.0.0

# Start the application with the server file
CMD ["node", "server.mjs"] 

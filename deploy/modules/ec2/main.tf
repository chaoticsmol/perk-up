data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Backend EC2 Instance
resource "aws_instance" "backend" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.medium"  # Upgraded from t2.micro for more memory
  key_name               = var.key_name
  subnet_id              = var.backend_subnet_id
  vpc_security_group_ids = [var.security_group_id]

  root_block_device {
    volume_size = 10
    volume_type = "gp2"
  }

  user_data = <<-EOF
    #!/bin/bash
    set -e

    # Install Docker
    amazon-linux-extras install docker -y
    systemctl start docker
    systemctl enable docker
    usermod -a -G docker ec2-user

    # Install Git
    yum install -y git

    # Clone the repository and checkout specific branch
    mkdir -p /app
    git clone https://github.com/chaoticsmol/perk-up.git /app
    cd /app
    git fetch origin asher/challenge
    git checkout asher/challenge

    # Create app directory if repo clone failed
    mkdir -p /app/backend

    # Create CORS configuration file
    cat > /app/backend/config/initializers/cors.rb << 'CORS'
    # Be sure to restart your server when you modify this file.

    # Avoid CORS issues when API is called from the frontend app.
    # Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

    # Read more: https://github.com/cyu/rack-cors

    Rails.application.config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'  # In production, you should restrict this to your frontend domain
        resource '*',
          headers: :any,
          methods: [:get, :post, :put, :patch, :delete, :options, :head],
          expose: ['Authorization']
      end
    end
    CORS
    
    # Create or update the backend Dockerfile
    cat > /app/backend/Dockerfile << 'DOCKERFILE'
    # syntax=docker/dockerfile:1
    # check=error=true

    ARG RUBY_VERSION=3.4.2
    FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

    # Rails app lives here
    WORKDIR /rails

    # Install base packages
    RUN apt-get update -qq && \
        apt-get install --no-install-recommends -y curl libjemalloc2 libvips sqlite3 && \
        rm -rf /var/lib/apt/lists /var/cache/apt/archives

    # Set production environment
    ENV RAILS_ENV="production" \
        BUNDLE_DEPLOYMENT="1" \
        BUNDLE_PATH="/usr/local/bundle" \
        BUNDLE_WITHOUT="development"

    # Throw-away build stage to reduce size of final image
    FROM base AS build

    # Install packages needed to build gems
    RUN apt-get update -qq && \
        apt-get install --no-install-recommends -y build-essential git libyaml-dev pkg-config && \
        rm -rf /var/lib/apt/lists /var/cache/apt/archives

    # Copy application code
    COPY . .

    # Add rack-cors gem to Gemfile if not already present
    RUN grep -q "gem 'rack-cors'" Gemfile || echo "gem 'rack-cors'" >> Gemfile

    # Install application gems
    RUN bundle install && \
        rm -rf ~/.bundle/ "$BUNDLE_PATH"/ruby/*/cache "$BUNDLE_PATH"/ruby/*/bundler/gems/*/.git && \
        bundle exec bootsnap precompile --gemfile

    # Create bin directory if it doesn't exist
    RUN mkdir -p /rails/bin

    # Make sure bin scripts are executable
    RUN chmod +x /rails/bin/* || true

    # Precompile bootsnap code for faster boot times
    RUN bundle exec bootsnap precompile app/ lib/

    # Final stage for app image
    FROM base

    # Copy built artifacts: gems, application
    COPY --from=build "$BUNDLE_PATH" "$BUNDLE_PATH"
    COPY --from=build /rails /rails

    # Ensure bin directory scripts are executable in the final stage
    RUN if [ -d /rails/bin ]; then chmod +x /rails/bin/*; fi

    # Create and set correct permissions on directories that need to be writable
    RUN mkdir -p /rails/config /rails/db /rails/log /rails/storage /rails/tmp && \
        chmod -R 777 /rails/config /rails/db /rails/log /rails/storage /rails/tmp

    # Run and own only the runtime files as a non-root user for security
    RUN groupadd --system --gid 1000 rails && \
        useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
        chown -R rails:rails /rails
    USER 1000:1000

    # Set environment variables for binding to all interfaces
    ENV BINDING="0.0.0.0"
    ENV PORT=${var.backend_port}

    # Start server
    EXPOSE ${var.backend_port}
    CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
    DOCKERFILE

    # Start the backend container
    docker build -t perk-up-backend /app/backend
    docker run -d -p 0.0.0.0:${var.backend_port}:${var.backend_port} \
      -e RAILS_ENV=production \
      -e BINDING=0.0.0.0 \
      -e PORT=${var.backend_port} \
      --name perk-up-backend perk-up-backend
  EOF

  tags = {
    Name = "perk-up-backend"
  }
}

# Frontend EC2 Instance
resource "aws_instance" "frontend" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.frontend_subnet_id
  vpc_security_group_ids = [var.security_group_id]

  root_block_device {
    volume_size = 10
    volume_type = "gp2"
  }

  user_data = <<-EOF
    #!/bin/bash
    set -e

    # Install Docker
    amazon-linux-extras install docker -y
    systemctl start docker
    systemctl enable docker
    usermod -a -G docker ec2-user

    # Install Git
    yum install -y git

    # Clone the repository and checkout specific branch
    mkdir -p /app
    git clone https://github.com/chaoticsmol/perk-up.git /app
    cd /app
    git fetch origin asher/challenge
    git checkout asher/challenge

    # Create app directory if repo clone failed
    mkdir -p /app/frontend
    
    # Create modified server.mjs file
    cat > /app/frontend/server.mjs << 'SERVERMJS'
    import express from "express";
    import path from "path";
    import { fileURLToPath } from "url";
    import { createProxyMiddleware } from 'http-proxy-middleware';

    const __filename = fileURLToPath(import.meta.url);
    const __dirname = path.dirname(__filename);
    const app = express();
    const PORT = process.env.PORT || ${var.frontend_port};
    const HOST = process.env.HOST || '0.0.0.0';
    const BACKEND_URL = process.env.BACKEND_URL || 'http://${aws_instance.backend.public_ip}:${var.backend_port}';

    // API routes can be added here
    app.get('/api/health', (req, res) => {
      res.json({ status: 'healthy' });
    });

    // Serve static files from the dist directory
    app.use(express.static(path.join(__dirname, 'dist')));

    // Set up proxy for /graphql endpoint
    app.use('/graphql', createProxyMiddleware({
      target: BACKEND_URL,
      changeOrigin: true,
      pathRewrite: {'^/graphql': '/graphql'},
      onProxyReq: (proxyReq, req, res) => {
        // Add CORS headers
        res.setHeader('Access-Control-Allow-Origin', '*');
        res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');
        res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type,Authorization');
        res.setHeader('Access-Control-Allow-Credentials', 'true');
      }
    }));

    // API proxy for other endpoints
    app.use('/api', (req, res) => {
      const proxyUrl = `$${BACKEND_URL}$${req.url}`;
      res.redirect(proxyUrl);
    });

    // Handle React routing, return all requests to React app
    app.get('*', (req, res) => {
      res.sendFile(path.join(__dirname, 'dist', 'index.html'));
    });

    app.listen(PORT, HOST, () => {
      console.log(`Server listening on $${HOST}:$${PORT}`);
      console.log(`Backend API URL: $${BACKEND_URL}`);
    });

    export default app;
    SERVERMJS

    # Create or update the frontend Dockerfile
    cat > /app/frontend/Dockerfile << 'DOCKERFILE'
    # Node.js version
    FROM node:20-slim AS base

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
    RUN npm ci --omit=dev --no-optional \
        && npm install http-proxy-middleware --save

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
    EXPOSE ${var.frontend_port}

    # Set host environment variable to listen on all interfaces
    ENV HOST=0.0.0.0
    ENV PORT=${var.frontend_port}
    ENV BACKEND_URL=http://${aws_instance.backend.public_ip}:${var.backend_port}

    # Start the application with the server file
    CMD ["node", "server.mjs"]
    DOCKERFILE

    # Start the frontend container
    docker build -t perk-up-frontend /app/frontend
    docker run -d -p ${var.frontend_port}:${var.frontend_port} -e BACKEND_URL=http://${aws_instance.backend.public_ip}:${var.backend_port} --name perk-up-frontend perk-up-frontend
  EOF

  depends_on = [aws_instance.backend]

  tags = {
    Name = "perk-up-frontend"
  }
} 
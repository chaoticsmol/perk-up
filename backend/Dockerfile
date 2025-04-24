# syntax=docker/dockerfile:1
# check=error=true

# This Dockerfile is designed for production, not development. Use with Kamal or build'n'run by hand:
# docker build -t perk_up_backend .
# docker run -d -p 80:80 -e RAILS_MASTER_KEY=<value from config/master.key> --name perk_up_backend perk_up_backend

# For a containerized dev environment, see Dev Containers: https://guides.rubyonrails.org/getting_started_with_devcontainer.html

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
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

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .

# Make sure bin scripts are executable
RUN chmod +x /rails/bin/*

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Final stage for app image
FROM base

# Copy built artifacts: gems, application
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Ensure bin directory scripts are executable in the final stage
RUN if [ -d /rails/bin ]; then chmod +x /rails/bin/*; fi

# Create and set correct permissions on directories that need to be writable
RUN mkdir -p /rails/config /rails/db /rails/log /rails/storage /rails/tmp && \
    chmod -R 777 /rails/config /rails/db /rails/log /rails/storage /rails/tmp

# Create a simple docker-entrypoint script
RUN mkdir -p /rails/bin && \
    echo '#!/bin/bash' > /rails/bin/docker-entrypoint && \
    echo 'if [ "${1}" = "./bin/rails" ] && [ "${2}" = "server" ]; then' >> /rails/bin/docker-entrypoint && \
    echo '  echo "Preparing database..."' >> /rails/bin/docker-entrypoint && \
    echo '  ./bin/rails db:prepare' >> /rails/bin/docker-entrypoint && \
    echo 'fi' >> /rails/bin/docker-entrypoint && \
    echo 'exec "$@"' >> /rails/bin/docker-entrypoint && \
    chmod +x /rails/bin/docker-entrypoint

# Create the thrust script
RUN echo '#!/bin/bash' > /rails/bin/thrust && \
    echo 'exec "$@"' >> /rails/bin/thrust && \
    chmod +x /rails/bin/thrust

# Create rails script if needed
RUN if [ ! -f /rails/bin/rails ]; then \
    echo '#!/bin/bash' > /rails/bin/rails && \
    echo 'exec bundle exec rails "$@"' >> /rails/bin/rails && \
    chmod +x /rails/bin/rails; \
    fi

# Run and own only the runtime files as a non-root user for security
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails /rails
USER 1000:1000

# Set environment variables for binding to all interfaces
ENV BINDING="0.0.0.0"

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start server via Thruster by default, this can be overwritten at runtime
EXPOSE 80
CMD ["./bin/thrust", "./bin/rails", "server"]

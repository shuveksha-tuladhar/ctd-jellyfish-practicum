# syntax=docker/dockerfile:1
FROM ruby:3.2.2-slim-bullseye

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update -qq && apt-get install --no-install-recommends -y \
  build-essential \
  libpq-dev \
  nodejs \
  yarn \
  curl \
  libvips \
  libsqlite3-dev \
  libyaml-dev \
  && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV RAILS_ENV=production \
    BUNDLE_DEPLOYMENT=true \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT=development:test

# Install gems using cached layer
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4 --retry 3

# Copy the rest of the application
COPY . .

# Copy entrypoint script
COPY entrypoint.sh /app/entrypoint.sh

# Precompile assets using a dummy secret (safe for build)
ENV SECRET_KEY_BASE=dummytoken1234
RUN RAILS_ENV=production NODE_ENV=production SECRET_KEY_BASE=$SECRET_KEY_BASE bundle exec rails assets:precompile

# Create a non-root user for security
RUN groupadd --system app && useradd --system --create-home --gid app appuser
RUN chown -R appuser:app /app
RUN chmod +x entrypoint.sh
USER appuser

ENTRYPOINT ["/app/entrypoint.sh"]

# Expose port for deployed server
EXPOSE 3002

# Start the Rails server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3002"]
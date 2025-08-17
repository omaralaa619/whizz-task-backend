# syntax = docker/dockerfile:1
ARG RUBY_VERSION=3.1.7
FROM ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails

# Install runtime dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      curl \
      libjemalloc2 \
      postgresql-client \
      libyaml-dev \
      libgmp-dev \
      zlib1g-dev \
      libffi-dev \
      && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

# Development environment, include all gems
ENV RAILS_ENV="development" \
    BUNDLE_PATH="/usr/local/bundle"

# -------------------
# Build stage
FROM base AS build
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      git \
      libpq-dev \
      pkg-config \
      libyaml-dev \
      zlib1g-dev \
      libffi-dev \
      && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .
RUN chmod +x bin/* && sed -i "s/\r$//g" bin/*

# -------------------
# Final runtime
FROM base
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

ENTRYPOINT ["/rails/bin/docker-entrypoint"]
EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]

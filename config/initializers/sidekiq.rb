# config/initializers/sidekiq.rb
require "sidekiq"
require "sidekiq/cron/job"

# Configure Redis connection for Sidekiq
Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch("REDIS_URL") { "redis://localhost:6379/0" } }

  # Schedule cron jobs when Sidekiq server starts
  Sidekiq::Cron::Job.create(
    name: "Delete old posts - every hour",
    cron: "0 * * * *", # every hour
    class: "PostCleanupWorker"
  )
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch("REDIS_URL") { "redis://localhost:6379/0" } }
end

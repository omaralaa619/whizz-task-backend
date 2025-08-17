class PostCleanupWorker
  include Sidekiq::Worker
  sidekiq_options queue: :default

  def perform
    # Delete posts older than 24 hours
    Post.where("created_at < ?", 24.hours.ago).destroy_all
  end
end

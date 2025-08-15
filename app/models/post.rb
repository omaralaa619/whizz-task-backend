class Post < ApplicationRecord
  belongs_to :user

  has_many :comments, dependent: :destroy  
  has_and_belongs_to_many :tags   
  has_one_attached :image          

  
  validates :title, presence: true
  validates :body, presence: true

  def image_url
    return unless image.attached?
    Rails.application.routes.url_helpers.rails_blob_url(image, only_path: false)
  end
end

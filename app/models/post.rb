class Post < ActiveRecord::Base
  belongs_to :user
  mount_uploader :image, ImageUploader
  extend FriendlyId
  friendly_id :subject, :use => :slugged
  default_scope order('created_at DESC')
    
  scope :published, lambda { |num = 3|
    where("published is true").
    order("created_at DESC").
    limit(num)
  }
  
  def self.sticky(num = 3)
    where("reviews.published is true and sticky is true")
    order("created_at DESC")
    limit(num)
  end
  
  def title
    subject
  end
  
end

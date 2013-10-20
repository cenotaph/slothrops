class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  belongs_to :book
  mount_uploader :image, NewcarouselUploader
  extend FriendlyId
  friendly_id :subject, :use => :slugged
  default_scope order('created_at DESC')
  before_save :update_image_attributes
  
  def update_image_attributes
    if image.present?
      self.image_content_type = image.file.content_type
      self.image_size = image.file.size
      self.image_width, self.image_height = `identify -format "%wx%h" #{image.file.path}`.split(/x/)
      # if you also need to store the original filename:
      # self.original_filename = image.file.filename
    end
  end
      
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
  
  def sortdate
    created_at
  end
  
end

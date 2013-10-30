class Staticpage < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, :use => :slugged
  mount_uploader :image, NewcarouselUploader
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
  
end

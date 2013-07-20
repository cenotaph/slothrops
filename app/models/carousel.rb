class Carousel < ActiveRecord::Base
  mount_uploader :image, CarouselUploader
  
  scope :published, where(:published => true)
end

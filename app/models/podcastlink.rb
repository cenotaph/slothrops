class Podcastlink < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  belongs_to :podcast
  validates_presence_of :name
end

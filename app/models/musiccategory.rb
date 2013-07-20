class Musiccategory < ActiveRecord::Base
  has_many :records
  extend FriendlyId
  friendly_id :name, :use => :slugged  
  default_scope order(:name)
end

class Category < ActiveRecord::Base
  has_many :books

  extend FriendlyId
  default_scope order(:name)
   friendly_id :name, :use => :slugged
  

  
  # scope :by_author, :order => "creators.displayname"
  # scope :by_acquired, :order => "inventories.acquired DESC"
  # scope :by_price, :order => "inventories.price DESC"
  
  FILTERS = [
    {:scope => "by_title", :label => 'Title'},
    # {:scope => "by_acquired", :label => 'Newest'},
    # {:scope => "by_author", :label => "Author"},
    # {:scope => "by_price", :label => "Price"}
  ]
  
end

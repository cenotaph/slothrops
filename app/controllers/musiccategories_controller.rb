class MusiccategoriesController < InheritedResources::Base
  actions :show
  has_scope :page, :default => 1  
  # has_scope :by_category, :as => :id
  # has_scope :sort_order, :default => "title"
  
  # has_scope :by_author
  # has_scope :by_price
  # has_scope :by_acquired
  before_filter :get_feed
  before_filter :get_recommended
  

  
end

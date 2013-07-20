class ReviewsController < InheritedResources::Base
  before_filter :get_feed
  
  def index
    @reviews = Review.where('published is true').includes([:book => [:creator, {:editions => [:inventories]}]]).order('created_at DESC')
  end
end
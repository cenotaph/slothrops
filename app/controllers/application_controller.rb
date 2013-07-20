class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "access denied: " +  exception.message
    redirect_to root_url
  end
  
  def get_feed
    @podcast = Podcast.published.first
    @feed = Post.published(2).order('created_at DESC')
    unless controller_name == 'events'
      @feed += Event.published(2).order('created_at DESC')
      @feed = @feed.sort_by{|x| x.created_at }.reverse[0..1]
    end
  end
  
  def get_recommended
    @featured = Inventory.includes([{:book => [ :creator]}]).available.featured.random(3)
    @reviews = Review.includes([{:book => [:creator]}]).where(:published => true).order('created_at DESC').limit(1)
  end
  
end

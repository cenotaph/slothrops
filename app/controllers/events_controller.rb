class EventsController < InheritedResources::Base
  actions :index, :show
  before_filter :get_feed, :except => :show
  before_filter :get_recommended, :only => :show
  
  def index
    @events = Event.published.order("start_at DESC")
  end
  
  
end

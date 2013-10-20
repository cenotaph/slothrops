class EventsController < InheritedResources::Base
  actions :index, :show
  before_filter :get_feed, :except => :show
  before_filter :get_token
  before_filter :get_recommended, :only => :show
  
  def index
    #@events = Event.published.order("start_at DESC")
    @graph = Koala::Facebook::API.new(@access_token)
    fetch_updated_events
    @events = Event.published.order("start_at DESC").page(params[:page]).per(5)
  end
  
  
end

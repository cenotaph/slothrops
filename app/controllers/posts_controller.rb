class PostsController < InheritedResources::Base
  actions :index, :show
  respond_to :html, :rss
  before_filter :get_recommended, :get_token

  
  def index
    params[:page] ||= "1"
    if params[:page] == "1"
      @graph = Koala::Facebook::API.new(@access_token)
      fetch_updated_events
      fetch_updated_posts
    end
    @posts = Post.published.order('created_at DESC').page(params[:page]).per(10)
  end
  

  
end

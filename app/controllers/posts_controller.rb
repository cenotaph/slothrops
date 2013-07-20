class PostsController < InheritedResources::Base
  actions :index, :show
  respond_to :html, :rss
  before_filter :get_recommended
  
  def index
    @posts = Post.published
  end
end

class PodcastsController < InheritedResources::Base
  actions :index, :show
  respond_to :html, :rss
  before_filter :get_recommended, :get_feed
  
  def index
    @podcasts = Podcast.published
  end
  
  def show
    @podcast = Podcast.find(params[:id])
    @title = "Slothrop's Screaming Sky podcast episode " + @podcast.name_and_number.gsub(/\-/, ' - ' )
    set_meta_tags :open_graph => {
      :title => @title,
      :type  => :podcast,
      :url   => 'http://slothrops.ee/podcasts/' + @podcast.slug,
      :image => 'http://' + request.host + @podcast.image.box.url
      }, 
      :canonical => 'http://slothrops.ee/podcasts/' + @podcast.slug,
      :keywords => @podcast.keywords,
      :description => @podcast.description,
      :title => @title
      
    if @podcast.published == false
      if current_user
        show!
      else
        flash[:error] = 'This does not exist'
        redirect_to '/' and return
      end
    else
      show!
    end
  end
  
end

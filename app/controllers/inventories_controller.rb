class InventoriesController < InheritedResources::Base
  has_scope :page, :default => 1
  
  before_filter :get_feed
  before_filter :get_recommended
  
  def featured
    @inventories = Inventory.includes([:category, {:book => [:collections, :creator]}]).featured.available.order("creators.surname").page(params[:page])
    render :template => 'inventories/featured'
  end
  
  # this is our homepage
  def index
    @latest = Storeitem.order('acquisition_date DESC').page(params[:page]).per(28)
    # @latest = Inventory.includes([:edition, :category, {:book => [:collections, :creator]}]).latest_arrivals.order('created_at DESC').limit(15)
    # @latest += ConsignmentItem.includes([:edition, :category, {:book => [:collections, :creator]}]).latest_arrivals.order('acquired DESC').limit(15).delete_if{|x| x.in_stock? == false }
    # @latest.sort!{|x, y| y.created_at <=> x.created_at }
  end
  
  def show
    @inventory = Inventory.find(params[:id])
    set_meta_tags :open_graph => {
      :title => @inventory.full_title,
      :description => @inventory.description,
      :image => 'http://' + request.host + @inventory.edition.image.box.url
    }, :title => @inventory.full_title
    super
    rescue ActiveRecord::RecordNotFound
      redirect_to '/books/' + params[:id]
  end
  
end

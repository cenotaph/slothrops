class CategoriesController < InheritedResources::Base
  has_scope :page, :default => 1  
  has_scope :by_category, :as => :id
  has_scope :sort_order, :default => "title"
  
  has_scope :by_author
  has_scope :by_price
  has_scope :by_acquired
  before_filter :get_feed
  before_filter :get_recommended
  
  def show
    @filters = Book::FILTERS
    @cat = Category.find(params[:id])
    @inventories = apply_scopes(Book).page params[:page]

    # .includes([:edition, :book]).where("sold = 0 and sale_id is null and books.category_id = ?", @cat.id).page params[:page]
    # inventories.each{|x| @inventories.push(x.book)}
    # @inventories =  Kaminari.paginate_array(@inventories).page(params[:page])
    set_meta_tags :title => @cat.name
    render :template => 'inventories/browse'
  end
  
end
``
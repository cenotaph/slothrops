class Admin::BooksController <  Admin::BaseController
  has_scope :page, :default => 1
  custom_actions :choose => :new
  respond_to :html, :xml, :json 
  # actions :create, :destroy, :update, :index
  
  def book_title=(title)
    book = Book.find_by_title(title)
    if book
      self.book_id = book.id
    else
      errors[:book_title] << "Invalid title entered"
    end
  end
  
  def book_title
    Book.find(book_id).title if book_id
  end
  
  def choose
    b = Edition.find_by_amazoncode(params[:amazon_code])
    if b.nil?
      b =  Amazon::Ecs.item_lookup(params[:amazon_code]).items.first
      @book = Book.new(:title => b.get('ItemAttributes/Title').to_s, :creator_name => b.get('ItemAttributes/Author').to_s)
      @edition = Edition.new(:amazoncode => params[:amazon_code])
      @book.editions << @edition
      @book.save!
      render :template => 'editions/new'
    else
      redirect_to admin_book_path( b.book)
    end

  end
  
  

  def create
    # @book.editions.build
    create!  do |success, failure|
      success.html {
        if @book.consignment_items.length == 0
           redirect_to admin_book_path(@book) 
        else
          redirect_to admin_consigner_path(@book.consignment_items.first.consigner)
        end
      }
      failure.html { 
        flash[:error] = @book.errors.inspect
        render :action => :edit }
    end
  end
  
  def home
    
  end
  
  def index
    if params[:book_title]
      @books = Book.includes(:creator).where("title LIKE '%" + params[:book_title].gsub(/[']/, '\\\\\'') + "%' OR creators.displayname LIKE '%#{params[:book_title].gsub(/[']/, '\\\\\'')}%'").page(params[:page])
      @searchterm = params[:book_title]
    elsif params[:sort]
      @books = Book.order(params[:sort]).page(params[:page])
    else
      @books = Book.includes(:editions => :inventories).order('inventories.updated_at DESC').page(params[:page])
    end
    

  end
  
  def new
    @book = Book.new
    @book.editions << Edition.new
    super
  end
  
  def query
    query = Book.query(params[:query]) if params[:query]
    if query.class == Array
      @queries = query
      render :template => 'admin/books/choose'
    else 
      asin = query.get('ASIN')
      edition = Edition.find_or_create_by_amazoncode(asin)
      if edition.book.nil?    # we don't have this edition yet, so...
        # but do we have another edition?
        author = query.get('ItemAttributes/Author')
        creator = Creator.find_or_create_by_displayname(author)      
        book = Book.where(:creator_id => creator.id, :title => query.get('ItemAttributes/Title').gsub(/\s+\(.+\)\s*/, ''))
        if book.empty?
          logger.warn('creating book')
          book = Book.create(:creator_id => creator.id, :title => query.get('ItemAttributes/Title').gsub(/\s+\(.+\)\s*/, ''))
        else
          book = book.first
        end
        
        edition.book = book
        edition.format = query.get('ItemAttributes/Binding').downcase

        edition.product_description = query.get('EditorialReviews/EditorialReview/Content')
        edition.remote_image_url = query.get_hash('LargeImage')['URL'] unless query.get_hash('LargeImage').nil?
        edition.save!
        @edition = edition
        @book = book
        render :template => 'admin/editions/new'
      else
        @inventory = Inventory.new(:edition => edition)
        render :template => 'admin/inventories/new'
      end
    end
  end

  def tag
    @book = Book.find(params[:id])
    @book.collection_list = params[:collections_list]
    @book.save
  end
  
  def update 
    update! { admin_book_path(@book)} 
  end
  
end



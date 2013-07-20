class Admin::RecordsController <  Admin::BaseController
  has_scope :page, :default => 1
  custom_actions :choose => :new
  respond_to :html, :xml, :json 
  # actions :create, :destroy, :update, :index
  
  def record_title=(title)
    record = Record.find_by_title(title)
    if record
      self.record_id = record.id
    else
      errors[:record_title] << "Invalid title entered"
    end
  end
  
  def record_title
    Record.find(record_id).title if record_id
  end
  
  def choose
    b = Edition.find_by_amazoncode(params[:amazon_code])
    if b.nil?
      b =  Amazon::Ecs.item_lookup(params[:amazon_code]).items.first
      @record = Record.new(:title => b.get('ItemAttributes/Title').to_s, :creator_name => b.get('ItemAttributes/Author').to_s)
      @edition = Edition.new(:amazoncode => params[:amazon_code])
      @record.editions << @edition
      @record.save!
      render :template => 'editions/new'
    else
      redirect_to admin_record_path( b.record)
    end

  end
  
  

  def create
    # @record.editions.build
    create! { admin_consigner_path(@record.consignment_items.first.consigner) }
  end
  
  def home
    
  end
  
  def index
    if params[:record_title]
      @records = Record.includes(:creator).where("title LIKE '%" + params[:record_title].gsub(/[']/, '\\\\\'') + "%' OR creators.displayname LIKE '%#{params[:record_title].gsub(/[']/, '\\\\\'')}%'").page(params[:page])
      @searchterm = params[:record_title]
    elsif params[:sort]
      @records = Record.order(params[:sort]).page(params[:page])
    else
      @records = Record.includes(:editions => :inventories).order('inventories.updated_at DESC').page(params[:page])
    end
    

  end
  
  def new
    @record = Record.new
    @record.editions << Edition.new
    super
  end
  
  def query
    query = Record.query(params[:query]) if params[:query]
    if query.class == Array
      @queries = query
      render :template => 'admin/records/choose'
    else 
      asin = query.get('ASIN')
      edition = Edition.find_or_create_by_amazoncode(asin)
      if edition.record.nil?    # we don't have this edition yet, so...
        # but do we have another edition?
        author = query.get('ItemAttributes/Author')
        creator = Creator.find_or_create_by_displayname(author)      
        record = Record.where(:creator_id => creator.id, :title => query.get('ItemAttributes/Title').gsub(/\s+\(.+\)\s*/, ''))
        if record.empty?
          logger.warn('creating record')
          record = Record.create(:creator_id => creator.id, :title => query.get('ItemAttributes/Title').gsub(/\s+\(.+\)\s*/, ''))
        else
          record = record.first
        end
        
        edition.record = record
        edition.format = query.get('ItemAttributes/Binding').downcase

        edition.product_description = query.get('EditorialReviews/EditorialReview/Content')
        edition.remote_image_url = query.get_hash('LargeImage')['URL'] unless query.get_hash('LargeImage').nil?
        edition.save!
        @edition = edition
        @record = record
        render :template => 'admin/editions/new'
      else
        @inventory = Inventory.new(:edition => edition)
        render :template => 'admin/inventories/new'
      end
    end
  end

  def tag
    @record = Record.find(params[:id])
    @record.collection_list = params[:collections_list]
    @record.save
  end
  
  def update 
    update! { admin_consigner_path(@record.consignment_items.first.consigner) }
  end
  
end



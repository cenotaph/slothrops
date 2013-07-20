class Admin::InventoriesController < Admin::BaseController

  has_scope :page, :default => 1
  
  def add_to_cart
    @sale = Sale.find(params[:sale_id])
    @inventory = Inventory.find(params[:inventory_id]) if params[:inventory_id]
    @sale.inventories << @inventory
    render :template => 'admin/sales/cart'
  end

  def adjustprice
    inventory = Inventory.find(params[:id])
    inventory.price += params[:amt].to_f
    inventory.jan2013audit = true
    if inventory.save
      flash[:notice] = 'Price adjusted by ' + params[:amt]
      redirect_to '/admin/inventories/audit'
    else
      flash[:error] = 'There was as error.'
      redirect_to '/admin/inventories/audit'
    end

  end
  
  def audit_query
    @hits = []
    hits = []
    hits << Edition.where(:barcode => params[:sales_lookup])
    hits << Book.includes(:creator).where("title LIKE '%" + params[:sales_lookup].gsub(/[']/, '\\\\\'') + "%' OR creators.displayname LIKE '%#{params[:sales_lookup].gsub(/[']/, '\\\\\'')}%'").map(&:editions).flatten
    records = Record.where("title LIKE '%" + params[:sales_lookup].gsub(/[']/, '\\\\\'') + "%' OR artist LIKE '%#{params[:sales_lookup].gsub(/[']/, '\\\\\'')}%'")
    items = ConsignmentItem.where("name LIKE '%" + params[:sales_lookup].gsub(/[']/, '\\\\\'') + "%'")

    @hits =  hits.flatten.map(&:inventories).flatten.compact

    @hits += hits.flatten.map(&:consignment_item).flatten.compact
    @hits += records.flatten.map(&:consignment_items).flatten.compact
    @hits += items.flatten.compact
    @hits.delete_if{|x| !x.in_stock? }

  end

  def audit_item
    @inventory = Inventory.find(params[:id])
  end

  def create
    create! { admin_books_path }
  end
  
  def inventory_title=(title)
    inventory = Inventory.find_by_title(title)
    if inventory
      self.inventory_id = Inventory.id
    else
      errors[:inventory_title] << "Invalid title entered"
    end
  end
  
  def inventory_title
    Inventory.find(inventory_id).title if inventory_id
  end

  def new
    if params[:edition_id]
      @inventory = Inventory.new(:edition_id => params[:edition_id])
      @no_edition = true
    else
      @inventory = Inventory.new
    end
    super
  end
  
  def index
    if params[:inventory_title]
      @inventories = Inventory.includes([:edition, :creator]).where("title LIKE '%#{params[:inventory_title]}%' OR creators.displayname LIKE '%#{params[:inventory_title]}%'").page(params[:page])
      @searchterm = params[:inventory_title]
    else
      @inventories = Inventory.includes([:edition, :creator, :book]).order("creators.surname").page(params[:page])
    end
  end
  
  def remove_from_cart
    @sale = Sale.find(params[:sale_id])
    i = Inventory.find(params[:inventory_id])
    @sale.inventories.delete(i)
    @sale.save!
    render :template => 'admin/sales/cart'
  end
  
  def start_cart
    @sale = Sale.new(:user => current_user)
    @inventory = Inventory.find(params[:inventory_id])
    @sale.inventories << @inventory
    @sale.save!
    render :template => 'admin/sales/cart'
  end

  def toggle_featured
    Inventory.find(params[:id]).toggle!(:featured)
    redirect_to admin_books_path
  end
  
  def update
    update! { '/admin/books'}
  end
end

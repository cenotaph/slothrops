class Admin::VouchersController < Admin::BaseController
  has_scope :page, :default => 1



  def add_to_cart
    @sale = Sale.find(params[:sale_id])
    @voucher = Voucher.new(:sale => @sale)
    render :template => 'admin/vouchers/new'
  end
  
  
  def create
    create! { admin_sale_path(@voucher.sale) }
  end
  
  def new
    add_to_cart
  end
    
  def update
    update! { admin_vouchers_path }
  end
  
  def remove_from_cart
    @sale = Sale.find(params[:sale_id])
    v = Voucher.find(params[:voucher_id])
    @sale.vouchers.delete(v)
    @sale.save!
    render :template => 'admin/sales/cart'
  end
  
  def start_cart
    @sale = Sale.create(:user => current_user)
    @voucher = Voucher.new(:sale => @sale)
    render :template => 'admin/vouchers/new'
  end
end

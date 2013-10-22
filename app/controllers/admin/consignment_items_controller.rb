class Admin::ConsignmentItemsController <  Admin::BaseController
  
  def add_to_cart_consignment
    @sale = Sale.find(params[:sale_id])
    @inventory = ConsignmentItem.find(params[:consignment_item_id]) if params[:consignment_item_id]
    @sale.consignment_items << @inventory
    render :template => 'admin/sales/cart'
  end

  def create
    create! { admin_consigner_path(@consignment_item.consigner) }
  end
  
  def destroy
    destroy! { admin_consigners_path }
  end

  def edit
    ci = ConsignmentItem.find(params[:id])
    if !ci.edition_id.blank?
      @book = ci.edition.book
      render :template => 'admin/consigners/new_book'  
    elsif !ci.record_id.blank?
      @record = ci.record
      render :template => 'admin/consigners/new_record'  
    end
  end

  def new
    @consignment_item = ConsignmentItem.new(:consigner_id => params[:consigner_id])
  end
  
  def remove_from_cart_consignment
    @sale = Sale.find(params[:sale_id])
    @inventory = ConsignmentItem.find(params[:consignment_item_id]) if params[:consignment_item_id]
    @sale.consignment_items.delete(@inventory)
    @sale.save
    render :template => 'admin/sales/cart'
  end
  
  def start_from_consignment
    @sale = Sale.new(:user => current_user)
    @inventory = ConsignmentItem.find(params[:consignment_item_id])
    @sale.consignment_items << @inventory
    @sale.save!
    render :template => 'admin/sales/cart'
  end
  
end

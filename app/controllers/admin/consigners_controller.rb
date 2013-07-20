class Admin::ConsignersController < Admin::BaseController

  def collect_payments
    c = Consigner.find(params[:id])
    c.consignment_sales.each do |cs|
      cs.payment_collected_at = Time.now
      cs.save!
    end
    redirect_to admin_consigner_path(c)
  end


  def new_book
    @book = Book.new
    @book.editions << Edition.new
    @book.editions.first.consignment_item = ConsignmentItem.new(:consigner_id => params[:id])
  end
    
  def new_record
    @record = Record.new
    @record.consignment_items << ConsignmentItem.new(:consigner_id => params[:id])
  end
  
  def sales_history
    @consigner = Consigner.find(params[:id])
  end
  
end

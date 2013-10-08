class Admin::SalesController < Admin::BaseController
  actions :new, :choose, :query, :apply_discount, :show, :destroy, :complete
  
  def add_comment
    @sale.comment = params[:comment]
    @sale.save!
    render :template => 'admin/sales/cart'    
  end

  def apply_discount
    @sale.discount = params[:discount].to_f
    @sale.discount_reason = params[:discount_reason]
    @sale.save!
    render :template => 'admin/sales/cart'
  end
  
  
  def choose
    
  end
  
  def complete
    if @sale.complete!
      # @sale.save!
      unless @sale.consignment_items.empty?
        @sale.consignment_items.each do |ci|
          # ConsignerMailer.item_sold(ci).deliver
        end
      else
        flash[:notice] = 'Sale completed.  PLEASE PLACE CONSIGNMENT MONEY IN ENVELOPES: ' + @sale.consignment_items.map{|x| x.wholesale.to_s + " for " + x.consigner.name }.join('; ')
        flash[:notice] = 'Sale completed.'
      end
    else
      flash[:error] = 'Sale cannot be completed -perhaps balance is still due?'
    end
    redirect_to admin_sale_path(@sale)
  end
  
  def csv_export
    require 'csv'
    @sales = Sale.closed.order(:sold_at)
    @outfile = "sales_" + Time.zone.now.strftime("%m-%d-%Y") + ".csv"
  
    csv_data = CSV.generate do |csv|
      csv << [
      "Sale id",
      "Date",
      "Item",
      "Price",
      
      "Sold by",

      ]
      @sales.each do |sale|
        sale.inventories.each do |inv|
          csv << [
            sale.id,
            sale.sold_at.nil? ? "" : sale.sold_at.strftime('%Y-%m-%d %H:%M'),
            inv.full_title,
            inv.price,
            sale.user.username
          ]
        end
        sale.vouchers.each do |vouch|
          csv << [
                        sale.id,
            sale.sold_at.nil? ? "" : sale.sold_at.strftime('%Y-%m-%d %H:%M'),
            'Gift voucher #' + vouch.try(:number),
            vouch.amount,
            sale.user.username
            ]
        end
      end
    end
    send_data csv_data,
      :type => 'text/csv; charset=iso-8859-1; header=present',
      :disposition => "attachment; filename=#{@outfile}"
    flash[:notice] = "Export complete!"
  end
  
    
  def destroy
    @sale = Sale.find(params[:id])
    @sale.inventories.each do |si|
      si.sale_id = nil
      si.sold = nil
      si.save!
    end
    @sale.destroy
    redirect_to admin_sales_path(:show => :opened)
  end
  
  
  def index
    @filters = Sale::FILTERS
    if params[:show] && @filters.collect{|f| f[:scope]}.include?(params[:show])
      @sales = Sale.send(params[:show]).includes([:payments, :vouchers, :user, :inventories, :consignment_items])
    elsif params[:opened_for]
      @sales = Sale.opened_for(params[:opened_for]).includes([:payments, :vouchers, :user, :inventories, :consignment_items])
      logger.warn('getting sales ' + @sales.inspect)
    else
      @sales = Sale.all
    end  
  end
  
  def query
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

    render :template => 'admin/sales/choose'
  end
  
  def show 
    @sale = Sale.find(params[:id])
  end
end

class Admin::ReportsController < ActionController::Base
  layout 'admin'
  respond_to :html, :csv
  before_filter :authenticate_user!
  # load_and_authorize_resource
  # check_authorization
  # load_and_authorize_resource
  skip_before_filter :require_no_authentication
  has_scope :page, :default => 1
  
  def credit_sales
    @start_date = params[:start_date]
    @end_date = params[:end_date]
    @credit_sales = Sale.closed.any_period(params[:start_date], params[:end_date]).map(&:payments).flatten.delete_if{|x| x.paymenttype_id != 2 }
    if params[:render_csv] == "1"
      render_csv("credit_sales-#{@start_date}", "credit_sales")
    end
  end

  def consigner_report
    @start_date = params[:start_date]
    @end_date = params[:end_date]
    @consigner = Consigner.find(params[:consigner_id])
    @document_number = params[:document_number]
    @vat_rate = params[:vat_rate]
    @items = @consigner.consignment_sales.closed.any_period(params[:start_date], params[:end_date]).group_by{|x| x.consignment_item}
    if params[:render_csv] == "1"
      render_csv("consigner_sales-#{@consigner.name.parameterize}-#{@start_date}", "consigner_sales")
    end
  end
  


  def daily_sales
    @start_date = params[:start_date]
    @end_date = params[:end_date]
    sales = Sale.closed.any_period(params[:start_date], params[:end_date]).group_by{|x| x.sold_at.to_date}
    (Date.parse(params[:start_date])..Date.parse(params[:end_date])).each do |d|
      if sales[d].nil?
        sales[d] = []
      end
    end
    @cgs = 0.0
    sales.each do |saleday|
      @cgs += saleday.last.map(&:inventories).flatten.map(&:our_cost).sum
    end
    @sales = Hash[sales.sort]
    if params[:render_csv] == "1"
      render_csv("daily_sales-#{@start_date}", "daily_sales")
    end

  end
  
  def expenses_cgs
    @start_date = params[:start_date]
    @end_date = params[:end_date]
    @expenses = Expense.any_period(params[:start_date], params[:end_date])
    sales = Sale.closed.any_period(params[:start_date], params[:end_date]).group_by{|x| x.sold_at.to_date}
    # sales.each do |saleday|
    #   @expenses << Expense.new(:expense_date => saleday.first,
    #       :recipient => 'Cost of books sold', 
    #       :description => "#{saleday.last.map(&:inventories).flatten.size} books",
    #         :amount => saleday.last.map(&:inventories).flatten.map(&:our_cost).sum) #all inventories sold
    # end
    @expenses = @expenses.sort_by{|x| x.expense_date}
    if params[:render_csv] == "1"
      render_csv("expenses_cgs-#{@start_date}", "expenses_cgs")
    end    
  end
  
  def inventory_acquisition
    @bookbuys = Bookbuy.closed.where(["day_of_sale >= ? AND day_of_sale <= ?", params[:start_date], params[:end_date]]).order(:day_of_sale)
    @start_date = params[:start_date]
    @end_date = params[:end_date]
    if params[:render_csv] == "1"
      render_csv("inventory_acquisition-#{@start_date}", "inventory_acquisition")
    end
  end
  
  def render_csv(filename = nil, template = nil)
    require 'csv'
    filename ||= params[:action]
    filename += '.csv'

    if request.env['HTTP_USER_AGENT'] =~ /msie/i
      headers['Pragma'] = 'public'
      headers["Content-type"] = "text/plain" 
      headers['Cache-Control'] = 'no-cache, must-revalidate, post-check=0, pre-check=0'
      headers['Content-Disposition'] = "attachment; filename=\"#{filename}\"" 
      headers['Expires'] = "0" 
    else
      headers["Content-Type"] ||= 'text/csv'
      headers["Content-Disposition"] = "attachment; filename=\"#{filename}\"" 
    end

    render :layout => false, :file => "#{Rails.root}/app/views/admin/reports/#{template}.csv.erb"
  end
  
  def undiscovered
    @inventories = Inventory.where("initialed is null").page params[:page]
    render :template => 'admin/inventories/index'
  end
  

end
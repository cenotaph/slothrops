class Admin::ExpensesController < Admin::BaseController
  def create 
    create! { admin_expenses_path }
  end
  
  def csv_export
    require 'csv'
    @expenses = Expense.all
    @outfile = "expenses_" + Time.now.strftime("%m-%d-%Y") + ".csv"
  
    csv_data = CSV.generate do |csv|
      csv << [
      "Expense id",
      "Date",
      "Recipient",
      "Description",
      "Amount",
      "Notes"
      ]
      @expenses.each do |expense|
        csv << [
          expense.id,
          expense.expense_date.nil? ? "" : expense.expense_date.strftime('%Y-%m-%d'),
          expense.recipient,
          expense.description,
          expense.amount,
          expense.notes
        ]
      end
    end
    send_data csv_data,
      :type => 'text/csv; charset=iso-8859-1; header=present',
      :disposition => "attachment; filename=#{@outfile}"
    flash[:notice] = "Export complete!"
  end
  
  def index
    @filters = Expense::FILTERS
    if params[:show] && @filters.collect{|f| f[:scope]}.include?(params[:show])
      @expenses = Expense.send(params[:show])
    else
      @expenses = Expense.all
    end  
  end
  
  def update
    update! { admin_expenses_path }
  end
end

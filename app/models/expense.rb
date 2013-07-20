class Expense < ActiveRecord::Base
  belongs_to :user
  
  scope :today, where("expense_date = ?", Time.now.strftime("%Y-%m-%d"))
  scope :this_week, where("expense_date >= ? AND expense_date <= ?", Time.now.beginning_of_week.to_date.to_s, Time.now.end_of_week.to_date.to_s)
  scope :this_month, where("expense_date >= ? AND expense_date <= ?", Time.now.strftime("%Y-%m-01"), (Date.new((Date.today>>1).year,(Date.today>>1).month,1)-1).to_s)
  scope :any_period, lambda { |start_date, end_date| where("expense_date >= ? AND expense_date <= ?", start_date, end_date) }
  
  FILTERS = [
              {:scope => "all",       :label => "All"},
              {:scope => "today", :label => 'Today'},
              {:scope => "this_week", :label => 'This week'},
              {:scope => "this_month", :label => "This month"}
            ]  
  
end


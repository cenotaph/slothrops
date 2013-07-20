class ConsignmentSale < ActiveRecord::Base
  belongs_to :consignment_item
  belongs_to :sale

  scope :any_period, lambda { |start_date, end_date| includes(:sale).where("date(sales.sold_at) >= ? AND date(sales.sold_at) <= ?", start_date, end_date) }
  scope :closed, includes(:sale).where("sales.sold_at is not null")
  scope :opened, includes(:sale).where("sales.sold_at is null")
  
end
class AddClearedToConsignmentSales < ActiveRecord::Migration
  def change
    add_column :consignment_sales, :payment_collected_at, :datetime, :default => nil
  end
end

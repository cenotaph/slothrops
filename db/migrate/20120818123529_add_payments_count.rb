class AddPaymentsCount < ActiveRecord::Migration
 
  def up
    add_column :sales, :payments_count, :integer, :default => 0
    add_column :sales, :vouchers_count, :integer, :default => 0
    Sale.reset_column_information
    Sale.find(:all).each do |p|
      Sale.update_counters p.id, :payments_count => p.payments.length
      Sale.update_counters p.id, :vouchers_count => p.vouchers.length
    end
  end

  def self.down
    remove_column :sales, :payments_count
    remove_column :sales, :vouchers_count
  end
end

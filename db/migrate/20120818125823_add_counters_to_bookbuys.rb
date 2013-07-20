class AddCountersToBookbuys < ActiveRecord::Migration
  def up
    add_column :bookbuys, :payments_count, :integer, :default => 0
    add_column :bookbuys, :inventories_count, :integer, :default => 0
    Bookbuy.reset_column_information
    Bookbuy.find(:all).each do |p|
      Bookbuy.update_counters p.id, :payments_count => p.payments.length
      Bookbuy.update_counters p.id, :inventories_count => p.inventories.length
    end
  end

  def self.down
    remove_column :bookbuys, :payments_count
    remove_column :bookbuys, :inventories_count
  end
end

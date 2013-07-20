class AddReviewsCount < ActiveRecord::Migration
  def up
    add_column :books, :reviews_count, :integer, :default => 0
    add_column :books, :consignment_items_count, :integer, :default => 0
    Book.reset_column_information
    Book.find(:all).each do |p|
      Book.update_counters p.id, :reviews_count => p.reviews.length
      Book.update_counters p.id, :consignment_items_count => p.consignment_items.length
    end
  end

  def self.down
    remove_column :books, :reviews_count
    remove_column :books, :consignment_items_count
  end
end
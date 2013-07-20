class AddPublishedToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :published, :boolean
    add_column :posts, :sticky, :boolean
    add_index :reviews, :slug, :unique => true
  end
  
end

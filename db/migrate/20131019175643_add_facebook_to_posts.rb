class AddFacebookToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :fb_id, :bigint
    add_column :posts, :fb_link, :string
    add_index :posts, :fb_id, :unique => true
  end
end

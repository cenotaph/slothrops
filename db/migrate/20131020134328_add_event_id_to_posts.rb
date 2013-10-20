class AddEventIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :event_id, :integer
    add_index :events, :fb_id, unique: true
  end
end

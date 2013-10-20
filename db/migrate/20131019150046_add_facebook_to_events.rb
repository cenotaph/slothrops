class AddFacebookToEvents < ActiveRecord::Migration
  def change
    add_column :events, :fb_id, :bigint
    add_column :events, :cover, :string
  end
end

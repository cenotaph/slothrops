class AddImagedataToEvents < ActiveRecord::Migration
  def change
    rename_column :events, :cover, :image
    add_column :events, :image_width, :integer
    add_column :events, :image_height, :integer
    add_column :events, :image_content_type, :string
    add_column :events, :image_size, :bigint
  end
end

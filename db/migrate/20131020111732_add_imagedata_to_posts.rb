class AddImagedataToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :image_size, :bigint
    add_column :posts, :image_content_type, :string
    add_column :posts, :image_height, :integer
    add_column :posts, :image_width, :integer
  end
end

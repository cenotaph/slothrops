class AddImageToStaticpages < ActiveRecord::Migration
  def change
    add_column :staticpages, :image, :string
    add_column :staticpages, :image_width, :integer
    add_column :staticpages, :image_size, :bigint
    add_column :staticpages, :image_height, :integer
    add_column :staticpages, :image_content_type, :string
  end
end

class AddShowoutofstockToTags < ActiveRecord::Migration
  def change
    add_column :tags, :show_out_of_stock, :boolean
    add_column :tags, :slug, :string
  end
end

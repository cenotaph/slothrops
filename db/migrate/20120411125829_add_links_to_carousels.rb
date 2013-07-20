class AddLinksToCarousels < ActiveRecord::Migration
  def change
    add_column :carousels, :url, :string
    add_column :carousels, :show_first, :boolean
  end
end

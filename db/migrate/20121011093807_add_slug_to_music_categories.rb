class AddSlugToMusicCategories < ActiveRecord::Migration
  def change
    add_column :musiccategories, :slug, :string
  end
end

class AddDescriptionToTags < ActiveRecord::Migration
  def change
    add_column :tags, :tag_description, :text
  end
end

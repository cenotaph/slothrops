class CreateStaticpages < ActiveRecord::Migration
  def change
    create_table :staticpages do |t|
      t.string :title
      t.text :body
      t.boolean :published
      t.string :slug
      t.timestamps
    end
    add_index :staticpages, :slug, :unique => true
  end
end

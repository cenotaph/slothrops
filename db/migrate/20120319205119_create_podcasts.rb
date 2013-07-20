class CreatePodcasts < ActiveRecord::Migration
  def change
    create_table :podcasts do |t|
      t.integer :number
      t.string :name
      t.string :url
      t.text :description
      t.boolean :published
      t.string :image
      t.string :slug
      t.timestamps
    end
  end
end

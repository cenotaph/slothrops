class CreatePodcastlinks < ActiveRecord::Migration
  def change
    create_table :podcastlinks do |t|
      t.string :name
      t.text :description
      t.string :url
      t.integer :order
      t.integer :podcast_id
      t.string :image
      t.timestamps
    end
  end
end

class CreateCreators < ActiveRecord::Migration
  def change
    create_table :creators do |t|
      t.string :sortname
      t.string :displayname
      t.string :first_name
      t.string :surname
      t.string :slug
      t.timestamps
    end
    add_index :creators, :slug, :unique => true
  end
end

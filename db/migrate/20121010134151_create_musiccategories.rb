class CreateMusiccategories < ActiveRecord::Migration
  def change
    create_table :musiccategories do |t|
      t.string :name

      t.timestamps
    end
  end
end

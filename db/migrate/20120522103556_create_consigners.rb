class CreateConsigners < ActiveRecord::Migration
  def change
    create_table :consigners do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.text :comments

      t.timestamps
    end
  end
end

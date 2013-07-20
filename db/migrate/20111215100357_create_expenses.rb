class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.date :when
      t.string :description
      t.float :amount
      t.string :notes
      t.references :user

      t.timestamps
    end
    # add_index :expenses, :user_id
  end
end

class CreateStoreitems < ActiveRecord::Migration
  def change
    create_table :storeitems do |t|
      t.string :title
      t.string :item_type
      t.integer :item_id
      t.date :acquisition_date
      t.float :price

      t.timestamps
    end
    Inventory.order('acquired DESC').limit(250).each do |i|
      Storeitem.create(:item_type => 'Inventory', :item_id => i.id, :acquisition_date => i.acquired, :price => i.price, :title => i.book.title)
    end
    ConsignmentItem.order('acquired DESC').limit(250).each do |i|
      Storeitem.create(:item_type => 'ConsignmentItem', :item_id => i.id, :acquisition_date => i.acquired, :price => i.price, :title => i.title)
    end
  end
end

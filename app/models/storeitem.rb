class Storeitem < ActiveRecord::Base
  attr_accessible :acquisition_date, :item_id, :item_type, :price, :title
  belongs_to :item, polymorphic: true
end

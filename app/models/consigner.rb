class Consigner < ActiveRecord::Base
  has_many :consignment_items
  has_many :consignment_sales, :through => :consignment_items
  has_many :sales, :through => :consignment_sales
  has_many :editions, :through => :consignment_items
  has_many :books, :through => :editions

  validates_presence_of :name, :email
  validates_uniqueness_of :email

  default_scope order('consignment_sales_count DESC')

  def owed
    consignment_sales.closed.delete_if{|x| !x.payment_collected_at.nil? }.map{|x| 
      x.consignment_item.wholesale.to_f }.sum
  end
  
end

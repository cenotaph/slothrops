class Bookbuy < ActiveRecord::Base
  belongs_to :user
  has_many :inventories
  validates_presence_of :source
  validates_presence_of :amount
  validates_presence_of :day_of_sale
  has_many :payments
  scope :opened, :conditions => ["closed is not true"]
  scope :closed, :conditions => ["closed is true"]
  
  def average_time_on_shelf
    if inventories.blank?
      0
    else
      (inventories.map{|x| x.time_on_shelf}.sum.to_f / inventories.size.to_f)
    end
  end
  
  def conversion_rate 
    if inventories.blank?
      0
    else
      (inventories.reject{|x| !x.sold}.size.to_f / inventories.size.to_f)*100
    end
  end
  
  def credit_left 
    unless payments.blank?
      creditamt - payments.delete_if{|x| x.amount.blank?}.map{|x| x.amount.to_f}.sum
    else
      creditamt.to_f
    end
  end
  
  def gross_profit
    if inventories.blank?
      0
    else
      # allsales = inventories.reject{|x| !x.sold}.map{|x| x.sale}.map{|x| x.payments.map{|y| y.amount.to_f}}.flatten
      allsales = inventories.reject{|x| !x.sold? }.map{|x| x.price.to_f }
      allsales.blank? ? 0 : allsales.sum
    end
  end
  
  def profit
    gross_profit -  amount
  end
  
end

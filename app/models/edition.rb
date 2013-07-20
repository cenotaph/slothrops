class Edition < ActiveRecord::Base
  belongs_to :book
  has_many :inventories, :dependent => :destroy
  has_one :consignment_item, :dependent => :destroy
  mount_uploader :image, ImageUploader
  # validates_presence_of :book_id
  # accepts_nested_attributes_for :inventories
  accepts_nested_attributes_for :consignment_item
  accepts_nested_attributes_for :book, :update_only => true

  

  def collection_list=(cl)
    book.collection_list = cl
    book.save!
  end

  def collection_list
    book.collection_list
  end

  def full_title
    out = book.title
    unless book.creator_name.blank?
      out += " by #{book.creator_name}"
    end
    return out
  end
  
  def in_stock
    if consignment_item.nil?
      inventories.delete_if{|x| x.sold == true }
    else
      consignment_item.remaining > 0 ? consignment_item : []
    end    
  end
  
  def in_stock?
    in_stock
  end
  
  def items
    if consignment_item.nil?
      inventories
    elsif inventories.empty? && !consignment_item.nil?
      [consignment_item]
    else
      [inventories, consignment_item]
    end
  end

  
end

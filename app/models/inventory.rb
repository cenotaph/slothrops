class Inventory < ActiveRecord::Base
  belongs_to :edition
  has_many :storeitems, as: :item, :dependent => :destroy
  mount_uploader :image, ImageUploader
  extend FriendlyId
  friendly_id :inventory_entry, :use => :slugged
  accepts_nested_attributes_for :edition, :update_only => true
  scope :available, where(:sold => false)  
  scope :featured, where(:featured => true) 
  has_many :payments, :through => :sale
  belongs_to :sale
  belongs_to :bookbuy, :counter_cache => true
  has_one :book, :through => :edition
  has_one :creator, :through => :book
  has_one :category, :through => :book
  attr_accessible :edition_id, :condition, :notes, :price, :edition, :bookbuy_id, :image_cache, :initialed, :notweet, :box, :omahind, :source
  attr_accessor :notweet
  after_create :check_twitter
  after_create :save_storeitem

  before_create :set_acquired
  before_save :update_image_attributes
  validates_presence_of :bookbuy_id
  
  def update_image_attributes
    if image.present?
      self.image_content_type = image.file.content_type
      self.image_size = image.file.size
      self.image_width, self.image_height = `identify -format "%wx%h" #{image.file.path}`.split(/x/)
      # if you also need to store the original filename:
      # self.original_filename = image.file.filename
    end
  end
  
  def save_storeitem
    Storeitem.create(:item_type => 'Inventory', :item_id => self.id, :title => self.title, :acquisition_date => self.acquired, :price => self.price)
  end
  

  def check_twitter
    if notweet == "1"
      logger.warn('do not tweet')
    else
      Twitter.update(self.full_title + ": " + "http://slothrops.ee/inventories/#{self.slug}") rescue nil
    end
  end

  def set_acquired
    if self.acquired.blank?
      self.acquired = Time.zone.now
    end
  end

  def self.latest_arrivals
    includes([:books, :category, :edition])
    where("sold is not true and sale_id is null and initialed is not null and price > 0")
  end
  
  def author
    edition.book.creator.displayname.blank? ? 'none' : edition.book.creator.displayname
  end
  # 
  # def self.featured(num = 3)
  #   order('rand()')
  #   where("featured is true and sold_at is null and sold is not true")
  #   limit(num)
  # end

  def format
    edition.format
  end
  
  def similar_sales
    samebook = book.editions.map{|x| x.inventories}.flatten.delete_if{|x| x.sold == false}.compact
    otherbyauthor = Creator.where(:displayname => book.author).map(&:books).flatten.delete_if{|x| x== book}.map(&:inventories).flatten.delete_if{|x| x.sold == false}.compact.sort_by{|x| x.updated_at}
    [samebook, otherbyauthor].flatten.compact
  end

  def full_title
    out = title
    unless edition.book.creator_name.blank?
      out += " by #{edition.book.creator_name}"
    end
    return out
  end
  
  def description
    edition.product_description.blank? ? "" : edition.product_description
  end
  
  def inventory_entry
    "#{author}--#{title}-#{id}"
  end
  
  
  def our_cost
    self.bookbuy.nil? ? 0 : (self.bookbuy.amount / self.bookbuy.inventories.size).to_f
  end

  def time_on_shelf
    if sold?
      (sale.created_at.to_date - bookbuy.day_of_sale).to_i
    else
      (Time.zone.now.to_date - bookbuy.day_of_sale).to_i
    end
  end
  
  def title
    edition.book.title.blank? ? 'untitled' : edition.book.title
  end
  
  def in_open_sale?
    unless sale.nil?
      sale.open?
    end
  end

  def in_stock?
    !sold?
  end
  
  def sold?
    return sold
  end
  
end

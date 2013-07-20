class Book < ActiveRecord::Base
  belongs_to :category
  belongs_to :creator
  has_many :editions, :dependent => :destroy
  has_many :consignment_items, :through => :editions
  has_many :inventories, :through => :editions
  has_many :reviews
  belongs_to :publisher
  accepts_nested_attributes_for :editions, :reject_if => proc { |attributes| attributes['format'].blank? }
  extend FriendlyId
  friendly_id :title_and_author, :use => :slugged
  # default_scope includes(:inventories).order('inventories.updated_at DESC')

  validates_presence_of :title
  # has_many :inventories, :through => :editions
  paginates_per 20
  acts_as_taggable
  acts_as_taggable_on :collections
  
  before_save :check_uppercase

  scope :by_category, lambda {|cat|
    includes(:creator).
    joins({:editions => :inventories }).
    where(["inventories.sold = 0 and inventories.sale_id is null AND category_id = ?", Category.find(cat).id])
  }
  
  scope :sort_order, lambda {|order|
    case order
    when "title"
      order("books.title")
    when "author"
      order("creators.displayname")
    when "acquired"
      order("inventories.acquired DESC")
    when "price"
      order("inventories.price DESC")
    when "cheap"
      order("inventories.price ASC")
    when "oldest"
      order("inventories.acquired ASC")
    else
      order("books.title")
    end
  }

  
  FILTERS = [
    {:scope => "title", :label => 'Title'},
    {:scope => "author", :label => "Author"},    
    {:scope => "acquired", :label => 'Newest acquisitions'},
    {:scope => "oldest", :label => "Oldest acquisitions"},
    {:scope => "price", :label => "Price (highest to lowest)"},
    {:scope => "cheap", :label => "Price (lowest to highest)"}
  ]
  

  
  def author
    creator.displayname
  end
  
  def title_and_author
    "#{author}--#{title}"
  end

  def check_uppercase
    if self.title =~ /^[^a-z]*$/
      self.title = self.title.titleize
    end
  end
  
  def creator_name
    creator.displayname unless new_record?
  end
  
  def creator_name=(name)
    self.creator =  Creator.find_or_create_by_displayname(name)
  end
  
  def editions_in_stock
    editions.delete_if{|x| x.in_stock.blank? }
  end
  
  def full_title
    out = title
    unless creator_name.blank? || creator_name =~ /none/i
      out += " by #{creator_name}"
    end
    return out
  end
  
  def in_stock
    editions.map{|x| x.items.delete_if{|x| x.sold == true || !x.sale_id.blank? }}.flatten + consignment_items.delete_if{|x| !x.in_stock? }
  end

  def in_stock?
    !in_stock.empty? 
  end

  def self.query(searchterm)
    hits = Edition.where(:barcode => searchterm)
    hits += Amazon::Ecs.item_search(searchterm, {:response_group => 'Medium'}).items
    if hits.size == 1
      return hits.first
    else
      results = []
      hits.each do |hit|
        if hit.class == Edition
          results << {"title" => hit.full_title + " (already in Slothrop's database)", "type" => "local", "key" => hit.id, 'image' => hit.image}
        else
          results << {"title" => hit.get('ItemAttributes/Title').to_s + ' by ' + hit.get('ItemAttributes/Author').to_s,
                    "key" => hit.get('ASIN'), "type" => "amazon",
                  'image' => hit.get('SmallImage').nil? ? nil : hit.get('SmallImage').gsub(/\<\/url\>.*/i, '').sub(/\<url\>/i, '')
                }
        end
      end
      return results
    end
  end

  def any_image(size = :midsize)
    editions.map{|x| x.image.url(size.to_sym) }.compact.first.blank? ? '/graphics/missing70-02.png' : editions.map{|x| x.image.url(size.to_sym) }.compact.first
  end

  def image(size = :midsize)
    any_image(size)
  end
  
    
  def any_description
    editions.map{|x| x.product_description }.compact.first
  end
  
  def items
    if consignment_items.delete_if{|x| !x.in_stock? }.empty?
      inventories
    elsif inventories.empty? && !consignment_items.empty?
      consignment_items
    else
      inventories + consignment_items
    end
  end
  
end

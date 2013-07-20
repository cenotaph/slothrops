class Creator < ActiveRecord::Base
  has_many :books
  has_many :posts
  extend FriendlyId
  friendly_id :displayname, :use => :slugged  
  
  before_create :fill_out
  before_save :check_uppercase

  def check_uppercase
    if displayname =~ /^[^a-z]*$/ && !displayname.nil?
      self.displayname = self.displayname.titleize
    end
  end
  
  def fill_out
    if displayname =~ /\w\s\w/
      names = displayname.split(/\s/)
      if names[1]
        self.first_name = names[0..(names.size-2)].join(' ')
        self.surname = names.last.strip
      end
      self.sortname = "#{surname}, #{first_name}"
    end
  end
  
end

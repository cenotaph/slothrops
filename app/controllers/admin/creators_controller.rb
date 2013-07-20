class Admin::CreatorsController < Admin::BaseController

  has_scope :page, :default => 1
  
  def create
    existing = Creator.find_by_displayname(params[:creator][:displayname])
    if existing.nil?
      create!
    else
      @creator = existing
      super
    end
  end
  
  
  def creator_title=(title)
    creator = Book.find_by_title(title)
    if creator
      self.creator_id = creator.id
    else
      errors[:creator_title] << "Invalid title entered"
    end
  end
  
  def creator_title
    Book.find(creator_id).title if creator_id
  end
  
  def index
    if params[:creator_name]
      @creators = Creator.includes(:books).where("displayname LIKE '%#{params[:creator_name]}%'").page(params[:page])
      @searchterm = params[:creator_name]
    else
      index!
    end
  end
  
  def update
    old = Creator.find(@creator)
    existing = Creator.find_by_displayname(params[:creator][:displayname])
    if existing.nil?
      update!
    elsif old == existing
      update!
    else
      Book.where(:creator_id => old.id).each do |book|
        book.creator = existing
        book.save!
      end
      old.destroy
      existing.update_attributes(params[:creator])
      redirect_to admin_creator_path(existing)
    end
  end
  
end

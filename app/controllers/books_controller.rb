class BooksController < InheritedResources::Base
  has_scope :page, :default => 1
  before_filter :get_recommended
  def book_title=(title)
    book = Book.find_by_title(title)
    if book
      self.book_id = book.id
    else
      errors[:book_title] << "Invalid title entered"
    end
  end
  
  def book_title
    Book.find(book_id).title if book_id
  end

  def index
    if params[:book_title]
      @books = Book.includes(:creator).where("title LIKE '%#{params[:book_title]}%' OR creators.displayname LIKE '%#{params[:book_title]}%'").page(params[:page])
      @searchterm = params[:book_title]
    else
      index!
    end
  end
  
  def show
    @book = Book.includes([:editions, :creator, :collections ]).find(params[:id])
    set_meta_tags :open_graph => {
      :title => @book.full_title,
      :description => @book.any_description
    }, :title => @book.full_title
    
    super
    rescue ActiveRecord::RecordNotFound
       render :template => 'shared/not_found'
  end
  
end

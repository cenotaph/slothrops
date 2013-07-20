class Admin::ReviewsController < Admin::BaseController
  
  before_filter :get_book
  
  
  protected

  
  def get_book
    @book = Book.find(params[:book_id]) if params[:book_id]
  end
  
end

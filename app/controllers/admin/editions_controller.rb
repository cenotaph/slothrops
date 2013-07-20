class Admin::EditionsController < Admin::BaseController

  has_scope :page, :default => 1
  
  before_filter :find_book 
  
  def destroy
    destroy! { admin_books_path }
  end

  def new
    @edition = Edition.new(:book_id => params[:id])
    @book.editions << @edition
  end

  
  def update
    @edition = Edition.find(params[:id])
    @edition.update_attributes(params[:edition])
    # relink/grab new amazon image
    unless params[:edition][:image]
      begin
        as = Amazon::Ecs.item_search(params[:edition][:amazoncode], {:response_group => 'Medium'}).items
          if as[0]
            product_description = as[0].get('EditorialReviews/EditorialReview/Content')
            @edition.product_description = product_description unless product_description.blank?
            @edition.remote_image_url = as[0].get_hash('LargeImage')['URL']
            @edition.save!
          end
        rescue 
          puts "can't get stuff: "
        end  
      end
       # logger.warn('url is ' + as[0].get_hash('LargeImage')['URL'])
      @edition.save!

      redirect_to admin_edition_path(@edition)
  end
  
  protected
  
  def find_book
    @book = Book.find(params[:book_id]) if params[:book_id]
  end
end

class ConsignmentItemsController < InheritedResources::Base
  has_scope :page, :default => 1
  
  before_filter :get_feed
  before_filter :get_recommended
  
  def show
    begin
      @inventory = ConsignmentItem.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        redirect_to '/books/' + params[:id]
    end
    if @inventory.edition
      @book = @inventory.book
      set_meta_tags :title => @book.title
      render :template => 'books/show'
    elsif @inventory.record
      set_meta_tags :title => @inventory.record.full_title
      render :template => 'records/show'
    else
      render :template => 'inventories/show'
    end
  end
  
end

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
    render :template => 'inventories/show'
  end
  
end

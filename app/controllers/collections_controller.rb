class CollectionsController < ApplicationController
  before_filter :get_feed
  
  def index
    @collections = Tag.all
  end
  
  def show
    @tag = Tag.find(params[:id])
    @collection = Book.includes([:creator, :collections, {:inventories =>    {:edition => [:consignment_item]}}, :category]).tagged_with(@tag.name)
    @collection += ConsignmentItem.tagged_with(@tag.name)
    @collection += Record.tagged_with(@tag.name)
    if @tag.show_out_of_stock != true
      # @collection.delete_if{|x| x.in_stock.empty? }
    end
    set_meta_tags :open_graph => {
      :title => @tag.name,
      :description => @tag.tag_description
    }, :title => @tag.name

  end
  
end
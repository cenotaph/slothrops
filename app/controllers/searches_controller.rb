class SearchesController < ApplicationController
  before_filter :get_feed  
  def create
    hits = Book.search params[:searchterm]
    hits += Edition.search params[:serchterm]
    hits += ConsignmentItem.search params[:searchterm]
    hits += Inventory.search params[:searchterm]
    hits.compact!
    @hits = []
    hits.each do |hit|
      if hit.class == Book
        @hits.push(hit) unless hit.in_stock.empty?
      elsif hit.respond_to?(:book)
        @hits.push(hit.book) unless hit.book.in_stock.empty?
      else
        @hits.push(hit)
      end
    end
    @hits.uniq!
    @searchterm = params[:searchterm]
  end
  
end

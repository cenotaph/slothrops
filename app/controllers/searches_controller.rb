class SearchesController < ApplicationController
  before_filter :get_feed
  
  
  def create
    if params[:searchterm].strip.size < 4
      flash[:error] = 'You must enter a longer search term'
      redirect_to '/'
    else
      hits = Book.includes(:creator).where("title LIKE '%" + params[:searchterm].gsub(/[']/, '\\\\\'') + "%' OR creators.displayname LIKE '%#{params[:searchterm].gsub(/[']/, '\\\\\'')}%'")
      # hits += Edition.where("product_description LIKE '%" + params[:searchterm].gsub(/[']/, '\\\\\'') + "%'")
      hits += ConsignmentItem.where("item_description LIKE '%" + params[:searchterm].gsub(/[']/, '\\\\\'') + "%'")
      # hits = Book.search params[:searchterm]
      # hits += Edition.search params[:serchterm]
      # hits += ConsignmentItem.search params[:searchterm]
      # hits += Inventory.search params[:searchterm]
      hits.compact!
      @hits = []
      hits.each do |hit|
        if hit.class == Book
          @hits.push(hit) unless hit.in_stock.empty?
        elsif hit.respond_to?(:book)
          if hit.book.nil?
            @hits.push(hit) if hit.in_stock? && hit.class == ConsignmentItem
          else
            @hits.push(hit.book) unless hit.book.in_stock.empty?
          end
        else
          @hits.push(hit)
        end
      end
      @hits.uniq!
      @searchterm = params[:searchterm]
    end
  end
  
end

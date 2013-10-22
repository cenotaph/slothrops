module InventoriesHelper

  def select_tag_for_filter(model, item, nvpairs, params)
    options = { :query => params[:query] }
    _url = url_for(eval("#{model}_url('#{item.slug.to_s}', options)"))
    _html = %{<label for="show" class="filter_label">Sort by:</label>}
    _html << %{<select name="show" id="show"}
    _html << %{onchange="window.location='#{_url}' + '?sort_order=' + this.value ">}
    nvpairs.each do |pair|
      _html << %{<option value="#{pair[:scope]}"}
      if params[:sort_order] == pair[:scope] #|| ((params[:show].nil? ||  params[:show].empty?) && pair[:scope] == "all")
        _html << %{ selected="selected"}
      end
      _html << %{>#{pair[:label]}}
      _html << %{</option>}
    end
    _html << %{</select>}
    _html.html_safe
  end

  #           
  # def paypal(stock)
  #   out = '<form target="paypal" method="post" action="https://www.paypal.com/cgi-bin/webscr">'
  #   out += '<input type="hidden" name="cmd" value="_cart">'
  #   out += '<input type="hidden" name="add" value="1">'
  #   out += '<input type="hidden" name="business" value="hy@slothrops.ee">'
  #   out += '<input type="hidden" name="item_name" value="' + stock.full_title + '">'
  #   out += '<input type="hidden" name="item_number" value="' + stock[:id].to_s + '">'
  #   out += '<input type="hidden" name="amount" value="' + stock.price.to_s + '">'
  #   out += '<input type="hidden" name="no_shipping" value="2">'
  #   out += '<input name="cancel_return" value="http://www.slothrops.ee" type="hidden">'
  #   out += '<input name="no_note" value="1" type="hidden">'
  #   out += '<input type="hidden" name="handling" value="2.00 ">'
  #   out += '<input type="hidden" name="currency_code" value="EUR">'
  #   out += '<input type="hidden" name="return" value="http://www.slothrops.ee">'
  #   out += '<input name="weight" value="' + (stock.edition.format =~ /^hard/i ? "0.51" : "0.4") + '" type="hidden">'
  #     out +=  '<input name="weight_unit" value="kgs" type="hidden">'
  #   out += '<input name="lc" value="EUR" type="hidden">'
  #   out += '<input name="bn" value="PP-ShopCartBF"type="hidden">'
  #   out += '<input type="image" src="http://www.paypalobjects.com/en_US/i/btn/x-click-but22.gif" border="0" name="submit" width="87" height="23"></form>'
  #   return out.html_safe
  # end
  
  def paypal(stock)
    if stock.sold?
      raw "<div class='oop'>Sorry, this item is not currently in stock.</div>"
    else
      if stock.respond_to?('stock_count') && stock.book.nil? && stock.record.nil?
        c = stock.remaining
      else
        c = ''
      end
      raw "<div class=\"order_now\">IN STOCK NOW!</div>"
    end
  end
  
end

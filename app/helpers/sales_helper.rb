module SalesHelper
  
  
  def chart_array(scope, unit = :hours, values = :sums)
    units = Hash.new
    if unit == :hours
      (10..20).each{|x| units[x.to_s] = Array.new }
    elsif unit == :days
      (1..7).each{|x| units[x.to_s] = Array.new }
    end
    
    scope.each{|x|
      next if x.sold_at.blank?
      chunk_sold = x.sold_at.localtime.strftime((unit == :hours ? "%H" : "%u")).to_i
      if unit == :hours && chunk_sold < 11
        chunk_sold = 10
      elsif chunk_sold > 20
        chunk_sold = 20
      end
      units[chunk_sold.to_s] << x 
    }
    out = Array.new
    units.each_key do |key|
      if values == :sums
        out.push(units[key].map{|x| x.payments_made }.sum)
      elsif values == :transactions
        out.push(units[key].size.to_i)
      elsif values == :items_sold
        out.push(units[key].map{|x| x.inventories.size}.sum)
      end
    end
    return out
  end
  
  def hourly_chart_array(scope)
    hours = Hash.new
    (10..20).each{|x| hours[x.to_s] = Array.new }
    scope.each{|x|
      hour_sold = x.sold_at.localtime.strftime("%H").to_i
      if hour_sold < 11 
        hour_sold = 10
      elsif hour_sold > 20
        hour_sold = 20
      end
      hours[hour_sold.to_s] << x }
    out = Array.new
    hours.each_key do |key|
      out.push(hours[key].map{|x| x.payments_made }.sum)
    end
    return out
  end
  

  def hourly_transactions_array(scope)
    hours = Hash.new
    (10..20).each{|x| hours[x.to_s] = Array.new }
    scope.each{|x|
      hour_sold = x.sold_at.localtime.strftime("%H").to_i
      if hour_sold < 11 
        hour_sold = 10
      elsif hour_sold > 20
        hour_sold = 20
      end
      hours[hour_sold.to_s] << x }
    out = Array.new
    hours.each_key do |key|
      out.push(hours[key].size)
    end
    return out
  end
  
  def daily_chart_array(scope)
    days = Hash.new
    # (10..20).each{|x| days[x.to_s] = Array.new }
    scope.each{|x| 
      if days[x.sold_at.localtime.strftime("%u")].nil?
        days[x.sold_at.localtime.strftime("%u")] = Array.new
      end
      days[x.sold_at.localtime.strftime("%u")] << x 
    }
    out = Array.new
    days.each_key do |key|
      out.push(days[key].map{|x| x.payments_made }.sum)
    end
    return out
  end
  
  def weekly_chart_for_hourly(scope, values = :sums)
    days = Hash.new
    (1..7).each{|x| days[x.to_s] = Array.new }
    scope.compact.each{|x| 
      next if x.sold_at.nil?
      if days[x.sold_at.localtime.strftime("%u")].nil?
        days[x.sold_at.localtime.strftime("%u")] = Array.new
      end
      days[x.sold_at.localtime.strftime("%u")] << x 
    }
    out = Array.new
    days.each_key do |key|
      if values == :sums
        out += chart_array(days[key], :hours, :sums)
      elsif values == :transactions
        out += chart_array(days[key], :hours, :transactions)
      elsif values == :items_sold
        out += chart_array(days[key], :hours, :items_sold)
      end
    end
    return out
  end
  
  def weekly_chart_for_transactions(scope)
    days = Hash.new
    (1..7).each{|x| days[x.to_s] = Array.new }
    scope.compact.each{|x| 
      next if x.sold_at.nil?
      if days[x.sold_at.localtime.strftime("%u")].nil?
        days[x.sold_at.localtime.strftime("%u")] = Array.new
      end
      days[x.sold_at.localtime.strftime("%u")] << x 
    }
    out = Array.new
    days.each_key do |key|
      out += hourly_transactions_array(days[key])
    end
    return out
  end
      
end
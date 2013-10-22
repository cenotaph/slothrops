module ApplicationHelper
  include AutoHtml

  def break_string_on_spaces(string, position, counter = 18)
    out = Array.new
    base = [0, find_nearest_space(string, position, counter)].flatten.compact
    base.each_with_index do |position, index|
      if index+1 == base.size
        out << string.slice(position..string.length).strip
      else
        out << string.slice(position..base[index+1]).strip
      end
    end
    return out
  end
  
  def find_nearest_space(string, start, counter = 18)
    return nil if string.nil?
    if start > string.length
      return
    else
      start.downto(start-counter) do |char|    
        splitchar = char
        if string.slice(char..char) =~ /\s/
          return Array.new.push(char, find_nearest_space(string, char + counter))
        end
      end
    end
  end
  
  def output(html)
    auto_html(html) { simple_format; link(:target => 'blank') }
  end
  
  def old_select_tag_for_filter(model, nvpairs, params)
    options = { :query => params[:query] }
    _url = url_for(eval("admin_#{model}_url(options)"))
    _html = %{<label for="show" class="filter_label">Show:</label><br />}
    _html << %{<select name="show" class="inline medium" id="show"}
    _html << %{onchange="window.location='#{_url}' + '?show=' + this.value">}
    nvpairs.each do |pair|
      _html << %{<option value="#{pair[:scope]}"}
      if params[:show] == pair[:scope] || ((params[:show].nil? || 
  params[:show].empty?) && pair[:scope] == "all")
        _html << %{ selected="selected"}
      end
      _html << %{>#{pair[:label]}}
      _html << %{</option>}
    end
    _html << %{</select>}
    raw _html
  end
  
  def truncate_words(text, length = 30, end_string = '&nbsp;&#8230;')
    words = text.split()
    out = words[0..(length - 1)].join(' ') + (words.length > length ? end_string : '')
    out.html_safe
  end
  
end

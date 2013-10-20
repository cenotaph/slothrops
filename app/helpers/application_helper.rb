module ApplicationHelper
  include AutoHtml
  
  def output(html)
    auto_html(html) { simple_format; link(:target => 'blank') }
  end
  
  def old_select_tag_for_filter(model, nvpairs, params)
    options = { :query => params[:query] }
    _url = url_for(eval("admin_#{model}_url(options)"))
    _html = %{<label for="show">Show:</label><br />}
    _html << %{<select name="show" id="show"}
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

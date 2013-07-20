xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    # Required to pass W3C validation.
    xml.atom :link, nil, {
      :href => posts_url(:format => 'rss'),
      :rel => 'self', :type => 'application/rss+xml'
    }
  
    # Feed basics.
    xml.title             "Slothrop's Books, Tallinn, Estonia"
    xml.description       "News and updates from Slothrop's."
    xml.link              posts_url(:format => 'rss')
  
    # Posts.
    @posts.each do |post|
      xml.item do
        xml.title         post.title
        xml.description do
          xml.cdata!post.body.gsub(/\n/, '<br />')
        end
        xml.link          post_url(post)
        xml.pubDate       post.created_at.to_s(:rfc822)
        xml.guid          post_url(post)
      end
    end
  end
end
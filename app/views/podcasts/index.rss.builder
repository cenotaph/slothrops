xml.instruct! :xml, :version=>"1.0"
xml.rss :version=>"2.0", "xmlns:itunes" => "http://www.itunes.com/dtds/podcast-1.0.dtd" do
  xml.channel do
    xml.title "Slothrop's Screaming Sky" 
    xml.description "A podcast from the Slothrop's English-language bookshop in Tallinn, Estonia dealing with life, literature, and the lackadaisacal."
    xml.link 'http://slothrops.ee/podcasts'
    xml.language 'en-us'
    xml.tag! "itunes:author", "Slothrop's"
    xml.tag! "itunes:subtitle", "A podcast from the Slothrop's English-language bookshop in Tallinn, Estonia dealing with life, literature, and the lackadaisacal."
    xml.tag! "itunes:summary", "A podcast from the Slothrop's English-language bookshop in Tallinn, Estonia dealing with life, literature, and the lackadaisacal."
    xml.tag! "itunes:owner" do
      xml.tag! "itunes:name", "Slothrop's"
      xml.tag! "itunes:email", "info@slothrops.ee"    
    end
    xml.tag! "itunes:category", :text => "Arts" do
      xml.tag! "itunes:category", :text => "Literature"
    end    
    xml.tag! "itunes:explicit", "No"
    xml.tag! "itunes:image", :href => "http://slothrops.ee/graphics/podcast_icon.jpg"

    @podcasts.published.each do |podcast|
      xml.item do  
        xml.title "##{podcast.number}: #{podcast.name}"
        xml.tag! "itunes:author", "Slothrop's"
        xml.tag! "itunes:summary", podcast.description
        xml.tag! "itunes:image", :href => "http://slothrops.ee#{podcast.image.url}"
        xml.description podcast.description
        xml.pubDate podcast.created_at.localtime.to_s(:rfc822)
        xml.link podcast_url(podcast)
        xml.guid podcast.url
        xml.category "Podcasts"
        xml.enclosure(:url => podcast.url,
          :length => File.size?(podcast.url.gsub(/^http\:\/\/[www\.]*slothrops\.ee/i, Rails.root.to_s + "/public")),
          :type => podcast.url =~ /m4a$/i ? "audio/x-m4a" : "audio/mpeg")
      end
    end
  end
end
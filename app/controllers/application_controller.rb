class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "access denied: " +  exception.message
    redirect_to root_url
  end
  
  def get_feed
    @podcast = Podcast.published.first
    @feed = Post.published(2).order('created_at DESC')
    unless controller_name == 'events'
      @feed += Event.published(2).order('created_at DESC')
      @feed = @feed.sort_by{|x| x.created_at }.reverse[0..1]
    end
  end
  
  def get_recommended
    @featured = Inventory.includes([{:book => [ :creator]}]).available.featured.random(3)
    @reviews = Review.includes([{:book => [:creator]}]).where(:published => true).order('created_at DESC').limit(1)
  end
  
  def frontpage
    get_token
    @graph = Koala::Facebook::API.new(@access_token)
    fetch_updated_events
    fetch_updated_posts
    @posts = Post.published.order('created_at DESC').page(params[:page]).per(10)
    @posts += Event.published.order("start_at DESC").page(params[:page]).per(5)
    @posts = @posts.sort_by{|x| x.sortdate}.reverse
  end
  
  protected

  def fetch_updated_events
    events = @graph.get_object('slothrops/events?fields=cover,name,description,start_time,end_time')
    events.each do |event|
      next if Event.exists?(:fb_id => event['id'])
      e = Event.create(:fb_id => event['id'], :title => event['name'], 
                      :start_at => event['start_time'].to_datetime + 8.hours, :facebook => event['link'], 
                      :end_at => (event['end_time'].blank? ? nil : event['end_time'].to_datetime + 8.hours), :description => event['description'],
                      :remote_image_url => event['cover']['source'], :published => true
                      )
    end
    
  end
  
  def fetch_updated_posts
    @graph = Koala::Facebook::API.new(@access_token)
    posts = @graph.get_object('slothrops/posts?limit=30')
    
    done = []
    posts.each do |post|
      # is it an event?
      if post['id'] =~ /\_/
        pid = post['id'].match(/([0-9])\_(\d*)/)[2]
      else
        pid = post['id']
      end
      next if Post.exists?(:fb_id => pid) || done.include?(pid)
      if post['link'] =~ /\.facebook\.com\/events\/(\d*)/
        event = Event.where(:fb_id => $1)
        unless event.empty?
          next if Post.exists?(:event_id => event.first.id)
          Post.create(:event => event.first, :subject => event.first.title,
                      :created_at => post['created_time'].to_datetime + 8.hours,
                      :body => event.first.start_at.strftime("%d %B, %Y at %H:%M") + " - " + event.first.description,
                      :published => true, :remote_image_url => event.first.image.url, :fb_link => post['link']
          )
        end
        next
      end
        
      next if post['type'] == 'status'
      done.push(pid)
      
      if post['description'].blank?
        body = post['message']
      else
        body = post['description'] 
      end
      next if body.blank?
      if post['name'].blank?
        subject = body.split(/\.\s/, 2).first
        body = body.split(/\.\s/, 2).last
      else
        subject = post['name']
      end
      
      if post['type'] == 'photo'
        ph = @graph.get_object(post['object_id'])
        Post.create(:subject => subject, :body => body,
                    :fb_id => pid, :fb_link => post['link'],
                    :remote_image_url => ph['images'].first['source'], :published => true,
                    :created_at => post['created_time'].to_datetime + 8.hours
                    )
      elsif post['type'] == 'link'
        Post.create(:subject => subject, :body => post['message'],
                    :fb_id => pid, :fb_link => post['link'],
                    :published => true, :created_at => post['created_time'].to_datetime + 8.hours
                    )
      end
    end
  end
  
  def get_token
    @oauth = Koala::Facebook::OAuth.new(FACEBOOK_APP_ID, FACEBOOK_SECRET, FACEBOOK_CALLBACK)
    @access_token = @oauth.get_app_access_token
  end
end

class StaticpagesController < InheritedResources::Base
  
  before_filter :get_recommended
  
end

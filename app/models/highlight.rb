require 'open-uri'

class Highlight < ActiveRecord::Base
  
  has_one :screenshot
  
  before_save :cache_src
  after_save :cache_image

  def self.thumbnails
    {
      :tiny =>"c38x24", 
      :large_furniture=>'349x500', 
      :mini=>"40x40", 
      :thumb => "50x50",  
      :furniture=>"72x72",  
      :medium=>'400x400>', 
      :enlarged=>'600x600' 
    }
  end
  
  def cache_image
    s = Screenshot.add(self)
   # s.generate
  end
  
  def cache_src
    self.src = open(url.to_s).read
  end  
  
  
end

require 'open-uri'

class Highlight < ActiveRecord::Base
  
  has_many :screenshots
  
  before_validation :repair_url
  before_save :cache_src
  after_save :cache_image
  
  def screenshot
    screenshots.first
  end

  def self.thumbnails
    {
      :thumb => "50x50",  
    }
  end
  
  def cache_image
    s = Screenshot.add(self)
   # s.generate
  end
  
  def cache_src
    self.src = open(url.to_s).read
  end
  
  def repair_url
    unless url.match(/^http/)
      self.url = "http://" + url.to_s
    end
  end
  
  
end

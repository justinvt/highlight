require 'open-uri'
require 'integer_addons'
require 'snapcasa'
class Highlight < ActiveRecord::Base
  
  has_many :screenshots
  
  before_validation :repair_url
  #before_create :cache_src
  after_create :cache_image

  
  def screenshot
    screenshots.first
  end

  def self.thumbnails
    {}
  end
  
  def make_tiny_url(scraped_url)
    tu = open("http://tinyarro.ws/api-create.php?url=#{scraped_url}").read
    update_attributes(:tiny_url=>tu)
  end
  
  def cache_image
    s = Screenshot.add(self)
  end
  
  def cache_src
    self.src = open(url.to_s).read
  end
  
  def repair_url
    unless url.match(/^http/)
      self.url = "http://" + url.to_s
    end
  end
  
  def width
    (x2-x1).to_px
  end
  
  def height
    (y2-y1).to_px
  end
  
  def top
    (y1-2).to_px
  end
  
  def left
    (x1-2).to_px
  end
  
  def background_position
    [(-x1).to_px,(-y1).to_px ]
  end
  
  def snapcasa
    screenshot.snapcasa
  end
  
  
  
end

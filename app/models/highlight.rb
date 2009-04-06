require 'open-uri'
require 'integer_addons'
require 'snapcasa'
class Highlight < ActiveRecord::Base
  
  has_many :screenshots, :dependent=>:destroy
  
  before_validation :repair_url
  #before_create :cache_src
  after_create :cache_image
 # after_save :make_tiny_url
  
  attr_accessor :from

  def screenshot
    screenshots.first
  end

  def self.thumbnails
    {}
  end
  
  def make_tiny_url(scraped_url)
    tu = open("http://tinyarro.ws/api-create.php?url=#{scraped_url}").read
    #update_attributes(:tiny_url=>self.class.generate_id(id))
    update_attributes(:tiny_url=>tu)
  end
  
  def cache_image
    s = Screenshot.add(self)
  end
  
  def cache_src
    self.src = open(url.to_s).read
  end
  
  def repair_url
     self.url = "http://" + url.to_s unless url.match(/^http/)
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
    snapshot.snapcasa(self)
  end
  
  def self.char_list
    ("0".."9").to_a + ("a".."z").to_a + ["_","-"]
  end
  
  def self.generate_id(obj_id)
   
    if obj_id.to_i <= 9 or all.blank?
       raise obj_id.to_s
      obj_id
    elsif (last.id % char_list.length) == 0
      last.tiny_url.to_s + char_list[0]
    else
      last.tiny_url[0..-2] + char_list[char_list.index(last.tiny_url.to_s[-1])]
    end
  end
  
end

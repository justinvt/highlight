require "rubygems"
require "rwebthumb"
require 'builder'

class Screenshot < ActiveRecord::Base
  
  include Simplificator::Webthumb
  
  belongs_to :highlight
  
  @@api_key = :dde49e22186a07b826e22770d1f78705
  @@user_id =  4461
  
    
  has_attachment :content_type => :image, 
                   :storage => :s3, 
                   :max_size => 4.megabytes,
                   :processor=> :rmagick,
              #   :resize_to => '700x400',
                   :thumbnails => {:thumb => "c50x50" }
  

  
  def self.add(highlight)
    filename = "#{RAILS_ROOT}/tmp/#{highlight.id}.jpg"
    thumb = Webthumb.new(@@api_key.to_s)
    job = thumb.thumbnail(:url => highlight.url)
    o = job.write_file(job.fetch_when_complete(:large), filename)
    #et = Easythumb.new(@@api_key.to_s, @@user_id.to_s)
    #et.build_url(:url => 'http://simplificator.com', :size => :full, :cache => 1)
    #raise et.inspect
    file_id = File.basename(filename)
    ext = File.extname(filename)
    file_base = file_id.gsub(ext,'')
    content_types = {
          ".gif" => "image/gif",
         ".ief" => "image/ief",
         ".jpe" => "image/jpeg",
         ".jpeg" => "image/jpeg",
         ".jpg" => "image/jpeg",
         ".pbm" => "image/x-portable-bitmap",
         ".pgm" => "image/x-portable-graymap",
         ".png" => "image/png",
         ".pnm" => "image/x-portable-anymap",
         ".ppm" => "image/x-portable-pixmap",
         ".ras" => "image/cmu-raster",
         ".rgb" => "image/x-rgb",
         ".tif" => "image/tiff",
         ".tiff" => "image/tiff",
         ".xbm" => "image/x-xbitmap",
         ".xpm" => "image/x-xpixmap",
         ".xwd" => "image/x-xwindowdump"
    }
    params = { 
      :temp_path => o, 
      :filename=>file_id, 
      :content_type=>content_types[ext]
    }
    img = self.create params
    img.update_attributes(:highlight_id=>highlight.id)
    File.delete(o.path)
  end
  
  def request
  end


  
end

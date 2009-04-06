require "rubygems"
require "rmagick"
require "rwebthumb"
require 'httparty'
require 'builder'
require 'net/http'
require 'rexml/document'
require 'snapcasa'

class Screenshot < ActiveRecord::Base
  
  include Simplificator::Webthumb
  include HTTParty
  include Magick


  format :xml
  
  belongs_to :highlight
  
  @@api_key = :dde49e22186a07b826e22770d1f78705
  @@user_id =  4461
  @@api_endpoint = "http://webthumb.bluga.net/api.php"
  @@format = "jpg"
  
    
  has_attachment :content_type => :image, 
                 :storage => :s3, 
                 :max_size => 4.megabytes,
                 :processor=> :rmagick
              #   :resize_to => '700x400',
              #   :thumbnails => {:thumb => "c50x50" }
  
  def self.content_types
    {
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
  end

  def self.add(highlight)
    Snapcasa.screenshot(highlight)
    filename = "#{RAILS_ROOT}/tmp/#{highlight.id}.#{@@format.to_s}"
    i = ImageList.new(filename)
    file_id = File.basename(filename)
    ext = File.extname(filename)
    file_base = file_id.gsub(ext,'')
    params = 
    img = self.create({ 
      :temp_path => filename,
      :filename=>file_id, 
      :content_type=>content_types[ext]
    })
    img.update_attributes(:highlight_id=>highlight.id, :width=>i.columns, :height=>i.rows)
    File.delete(filename)
  end
  
  def job_request
%{<webthumb>
    <apikey>#{@@api_key}</apikey>
    <request>
      <url>#{highlight.url.to_s}</url>
      <fullthumb>1</fullthumb>
    </request>
</webthumb>}.gsub(/[\n \t\\]+/,'')
end

  def job_request
%{<webthumb>
    <apikey>#{@@api_key}</apikey>
	  <fetch>
		  <job>#{job_id}</job>
		<size>full</size>
	</fetch>
</webthumb>}.gsub(/[\n \t\\]+/,'')
end

  def img_request
%{<webthumb>
    <apikey>#{@@api_key}</apikey>
    <request>
      <url>#{highlight.url.to_s}</url>
      <fullthumb>1</fullthumb>
  
      <height>2048</height>
    </request>
</webthumb>}.gsub(/[\n \t\\]+/,'')
end
  
  def request_components
    {:webthumb => {
          :apikey => @@api_key.to_s,
          :request => {
            :url => highlight.url.to_s,
            :fullthumb => 1
          }
      }
    }
  end
  
  def full_size
    self.class.post(@@api_endpoint, :query => request_components).inspect
  end
  
  def via_curl(xml)
    (IO.popen "curl -X POST #{@@api_endpoint} -d \"#{xml}\"").read
  end

  def get_job_id
    p = via_curl(img_request).gsub(/[\n \t\\]+/,'').scan(/[a-zA-Z0-9]+<\/job>/)[0].gsub(/<\/job>/,'')
    update_attributes(:job_id=>p)
  end
  
  def snapcasa_url
    Snapcasa.url_for(highlight)
  end
  
  def curl_command
    Snapcasa.curl_command(highlight)
  end
  
  def snapcasa
    d = Snapcasa.screenshot(highlight)
  end
  
  def save_image(data)
    File.open(File.join(RAILS_ROOT,'tmp', highlight.id.to_s + '.jpg'), 'w+').puts(data)
  end
  
  def get_image
   #save_image(via_curl(job_request))
   snapcasa
  end
  
  def fetch_full
    get_job_id
    sleep 20
    get_image
  end
  
end
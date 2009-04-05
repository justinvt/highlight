class Snapcasa
  
  @@user_id = 5138
  @@compression = 95
  @@format = "PNG"
  
  def self.url_for(highlight)
    "http://snapcasa.com/get.aspx"
  end
  
  def self.curl_command(highlight)
    "curl -G -d \"key=MKZER8Z&code=#{@@user_id}&width=800&height=2000&page=1&file=#{@@format}&url=#{highlight.url}\" http://snapcasa.com/get.aspx"
  end
  
  def self.screenshot(highlight)
    system "#{curl_command(highlight)} > tmp/#{highlight.id}.#{@@format.downcase.to_s}"
    #sleep 10
    #o = p.read
    #p.close
    #o
   # p.read
  end


end
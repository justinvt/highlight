
require 'logger'
s3_config_path=(RAILS_ROOT + '/config/amazon_s3.yml')
#TODO
@application = "nooknack"
@keypair_prefix = "id_rsa-"
@keypair = File.read("config/deploy.rb").scan(Regexp.new("#{@keypair_prefix}[-_a-zA-Z]+"))[0]
@key=@keypair
@amis_file = File.join(RAILS_ROOT,'config','amis')
@deploy_file = File.join(RAILS_ROOT,'config','deploy.rb')
@ami_file = File.join(RAILS_ROOT,'config','ami')
@instance_file = File.join(RAILS_ROOT,'config','instances')
@ami = ''
@env_settings = "/Users/justin/.bash_profile"
@domain_regex = Regexp.new("ec2[^ \t\n\r,]+.com")
@instance_regex = Regexp.new("i\-[a-z0-9]+")
@hostname = RAILS_ENV['domain'] || "dev.nooknack.com"
@ec2_home = ENV['EC2_HOME']

def ask message
  print message
  STDIN.gets.chomp
end

def ami
  File.open(@ami_file, "r").strip
end

def instance_domain
  view_instance
  File.open(@instance_file,"r+").read.to_s.gsub(/\t/,",").gsub(/[\n\r]+/,'').scan(@domain_regex)[-1].to_s
end

def instance_ip
  instance_domain.gsub(/[^0-9\-]+/,'').gsub(/^2\-|-[0-9]{1}$/,'').gsub('-','.')
end

def instance_id
  view_instance
  most_recent.scan(@instance_regex)[0].to_s
end

def volume_id
  deploy = File.open(@deploy_file).read
  deploy.scan(/vol\-[a-z0-9]+/)[0]
end

def file_repace(file,regex,replacement)
  deploy = File.open(file).read.gsub(regex,replacement)
  f = File.open(file, "w+")
  f.puts deploy
  f.close
  deploy
end

def replace_domain
  deploy = File.open(@deploy_file).read.gsub(@domain_regex, instance_domain)
  f = File.open(@deploy_file, "w+")
  f.puts deploy
  f.close
  deploy
end

def parse_instances
  instances = File.open(@instance_file).read.gsub(/\t/,",").gsub(/[\n\r]+/,'').scan(/RESERVATION[^R]+/).to_a.collect{|i| i.gsub(",",'  ')}
end

def most_recent
  parse_instances[-1]
end

def view_instance
  command = 'ec2-describe-instances'
  p = IO.popen command
  f = File.open(@instance_file, "w+")
  f.puts(p.read)
  f.close
  return
end

def begin_instance(ami,keypair)
  run_command = "ec2-run-instances #{ami} -k #{keypair}"
  puts "Running AMI..."
  puts run_command
  system run_command
  "Setting permissions"
  10.times do |i|
    sleep(1)
    print "."
  end
  allow_command = "ec2-authorize default -p 22 -p 80"
  puts allow_command
  system allow_command
  puts "Ports 22 and 80 are now accessible."
  view_instance
end

#GO DADDY USES THESE IN CASE WE NEED TO REVERT
# NS13.DOMAINCONTROL.COM
# NS14.DOMAINCONTROL.COM


namespace :ec2 do
  
  task :ins => [:environment] do
    puts instance_id
  end
  
  task :fix_env => [:environment] do
    cert = Dir.new(@ec2_home).entries.select{|i| i.match(/^cert/) != nil }[0]
    key = cert.match(/[A-Z0-9]+/)[0]
    File.open(@env_settings,"a").puts("##{@application} certificate\nexport KEYNAME=#{key}")
    system "source #{@env_settings}"
  end
  
  task :keypair => [:environment] do
    unless File.exist?(File.join(@ec2_home, @keypair_prefix + @keypair.to_s))
      command = "cd #{@ec2_home};ec2-add-keypair #{@keypair}> #{@key};chmod 600 #{@keypair_prefix}*; chmod 755 lib bin"
      system command
    end
  end
    
  desc "Show the volume we are using to hold mysql database - this just reads it from deploy.rb"
  task :volume => [:environment] do
    puts volume_id
  end
  
  task :snapshot => [:environment] do
    command = "ec2-create-snapshot #{volume_id}"
    system command
  end
  
  desc "Show most recent ec2onrails amis and write to /config/amis"
  task :ami_ids => [:environment] do
    puts "Recording available ec2onrails ami's"
    command = "cap ec2onrails:ami_ids"
    p = IO.popen command
    f = File.open(@amis_file, "w+")
    r = f.puts(p.read)
    f.close
  end
  
  task :locate_sendmail => [:environment] do
    puts "Locating Sendmail"
    regexp = '^/[\/a-z]+sendmail$'
    command = "whereis sendmail | grep -o -E '#{regexp}'"
    p = IO.popen command
    config_file = File.join(RAILS_ROOT, 'config','environments',RAILS_ENV.to_s + ".rb")
    puts "Replacing contents of #{config_file}"
    file_repace(config_file,Regexp.new(regexp),p.read)
  end
  
  desc "Use the ec2onrails get ami_ids command to create a list of amis and allow the user to choose one which will be stored in config/ami"
  task :start => [:environment] do
    ami_list = File.open(@amis_file, "r+").read.split(/[\n\r]/)
    n = ami_list.size
    i = 0
    amis = ami_list.collect{|g| (i=i+1).to_s + " ) " + g }.join("\n")
    puts
    puts amis.to_s
    puts

    number = ask "Choose the instance you'd like to start (#{1.upto(n).to_a.join(',')}) \n"
    if (1..n).include? number.to_i
      ami = ami_list[number.to_i-1]
      ami_id = ami.to_s.match(/ami\-[0-9a-z]+/)[0]
      @ami = ami_id
      puts "#{ami_id}"
      f = File.open(@ami_file,"w+")
      f.puts(ami_id)
      f.close
    else
      puts "That's not a valid choice"
      number = nil
    end
  end
  
  desc "Start the instance stored in config/ami - Useful to avoid default selections which are buggy"
  task :begin=> [:environment] do
    @ami = File.open(@ami_file).read.strip
    puts "Beginning instance #{@ami} with keypair #{@keypair}"
    wait_time = 40
    begin_instance(@ami,@keypair)
    puts "We're going to sleep  for #{wait_time} seconds  while your instance domain is designated.  We apologize for the delay."
    wait_time.times do |i|
      sleep(1)
      puts wait_time-i
    end
    view_instance
  end

  #SSH into server as admin by default.  Set RUSER=username to login as something like root or app
  desc "SSH into server as admin or RUSER=username (For now there is admin, root or app)"
  task :ssh => [:environment] do
    user = ENV['RUSER'] || "admin"
    ssh_command = "ssh -i #{File.join(@ec2_home, @keypair)} #{user}@#{instance_domain}"
   # puts ssh_command
    system ssh_command
  end
  
  #Copy keys from ~/.ec2 locally to /mnt remotely - This is to help with bundling our instance
  desc "Copy keys"
  task :copy_keys => [:environment] do
    puts "Copying ssh keys and ec2 certs to your instance"
    copy_command = "scp -i #{@ec2_home}/#{@key} #{@ec2_home}/{cert,pk}-*.pem root@#{instance_domain}:/mnt/"
    puts copy_command
    system copy_command
  end
  
  desc "Write all instance data to config/instances and modify deploy.rb"
  task :instance => [:environment] do
    view_instance
    puts instance_domain
    puts "Replacing ec2 domain with #{replace_domain}"
  end
  
  #This is 99% of what we need to do to get the instance up and running as of 2/16/09, but ec2onrails moves quickly.  Was ok as of 0.9.9.1
  desc "Server prep"
  task :prep =>[:environment] do
    prep_command = "cap ec2onrails:setup && cap ec2onrails:server:set_rails_env &&  cap deploy:cold && cap ec2onrails:server:set_rails_env && cap deploy:setup && cap start_ferret && cap deploy"
    system prep_command
  end
  
  
  desc "Assign last unassigned ec2 IP to our instances"
  task :assign => [:environment] do
    assign_command = "ec2-describe-addresses | grep -v -e \"i\-\" | tail -1"
    address = IO.popen(assign_command).read.to_s.match(/[0-9\.]+/)[0]
    if address.length >= 8
      associate = "ec2-associate-address -i #{instance_id}  #{address}"
      system associate
      sleep(10)
      instance
    end
  end

  
  desc "Create ami list, prompt for which ami and then start it up"
  task :activate => [:ami_ids, :start, :begin, :instance, :ssh, :prep ]
  
  desc "on OSX ONLY SO FAR configure bash_profile, generate keypair and then go through the instance selection/activation"
  task :all => [:fix_env, :keypair, :activate]
  

end
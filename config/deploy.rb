set :application, "highlight"
set :rails_env, "production"

set :repository,  "git://github.com/justinvt/highlight.git"

set :scm_user, "nook"
set :scm_verbose, true
set :scm, :git

set :branch, "master"
set :hostname, 'ec2-75-101-164-86.compute-1.amazonaws.com'
set :volume, 'vol-ac4da9c5'

ssh_options[:keys]          =  ["/Users/justin/.ec2/id_rsa-freshout"]
ssh_options[:forward_agent] =  true
ssh_options[:config]        =  false

default_run_options[:pty] = true
set :deploy_via, :remote_cache

before "deploy:cold", :repair_image_magick

role :web,     hostname
role :app,     hostname
role :db,      hostname, :primary => true#,  :ebs_vol_id => 'vol-2f7e9a46'
role :memcache,hostname

task :repair_image_magick, :roles=>[:app_admin] do
  sudo "aptitude update"
  sudo "aptitude install imagemagick -y"
  sudo "apt-get install librmagick-ruby  --yes"
  sudo "apt-get install libmagick9-dev --yes"
  sudo "gem install rmagick"
end

# EC2 on Rails config. 
# NOTE: Some of these should be omitted if not needed.
set :ec2onrails_config, {
  # S3 bucket and "subdir" used by the ec2onrails:db:restore task
  :restore_from_bucket => "nooknack_archive",
  :restore_from_bucket_subdir => "last_good",
  
  # S3 bucket and "subdir" used by the ec2onrails:db:archive task
  # This does not affect the automatic backup of your MySQL db to S3, it's
  # just for manually archiving a db snapshot to a different bucket if 
  # desired.`
  :archive_to_bucket => "highlight_archive",
  :archive_to_bucket_subdir => "ec2db/#{Time.new.strftime('%Y-%m-%d--%H-%M-%S')}",
  
  # Set a root password for MySQL. Run "cap ec2onrails:db:set_root_password"
  # to enable this. This is optional, and after doing this the
  # ec2onrails:db:drop task won't work, but be aware that MySQL accepts 
  # connections on the public network interface (you should block the MySQL
  # port with the firewall anyway). 
  # If you don't care about setting the mysql root password then remove this.
  :mysql_root_password => "h1ghl1ght",
  
  # Any extra Ubuntu packages to install if desired
  # If you don't want to install extra packages then remove this.
  :packages => ["logwatch", "imagemagick"],
  
  # Any extra RubyGems to install if desired: can be "gemname" or if a 
  # particular version is desired "gemname -v 1.0.1"
  # If you don't want to install extra rubygems then remove this
  :rubygems => ["tzinfo", "", "hpricot", "BlueCloth", "RedCloth", "ferret", "rails -v 2.3.2"],
  
  # Set the server timezone. run "cap -e ec2onrails:server:set_timezone" for 
  # details
  :timezone => "US/Eastern",
  
  # Files to deploy to the server (they'll be owned by root). It's intended
  # mainly for customized config files for new packages installed via the 
  # ec2onrails:server:install_packages task. Subdirectories and files inside
  # here will be placed in the same structure relative to the2 root of the
  # server's filesystem. 
  # If you don't need to deploy customized config files to the server then
  # remove this.
  #:server_config_files_root => "../server_config",
  # If config files are deployed, some services might need to be restarted.
  # If you don't need to deploy customized config files to the server then
  # remove this.
  :services_to_restart => %w(apache2 postfix sysklogd),

  # Set an email address to forward admin mail messages to. If you don't
  # want to receive mail from the server (e.g. monit alert messages) then
  # remove this.
  :admin_mail_forward_address => "admin@highlig.ht",
  
  # Set this if you want SSL to be enabled on the web server. The SSL cert 
  # and key files need to exist on the server, The cert file should be in
  # /etc/ssl/certs/default.pem and the key file should be in
  # /etc/ssl/private/default.key (see :server_config_files_root).
  :enable_ssl => true
}


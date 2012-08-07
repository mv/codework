#
# Ref: http://jonathanjulian.com/category/capistrano/
#
desc "Generate the apache httpd.conf file from the template"
task :generate_apache_httpd_conf_file, :roles => :app do

  require 'erb'
  # set up defaults for some vars to go into the template. others are required.
  apache_processes    = fetch(:www_procs, 2)
  max_rails_processes = fetch(:max_rails_procs, 2)
  ruby_binary         = fetch(:ruby_binary, "ruby")
  gem_home            = fetch(:gem_home, '/usr/local/lib/ruby/gems/1.8/gems')
  behind_https        = fetch(:fronted_by_https, false)

  template = ERB.new(File.read('config/templates/httpd.conf.erb'), nil, '<>')
  result   = template.result(binding)
  put(result, "#{current_release}/httpd.conf")
end


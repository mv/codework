require File.dirname(__FILE__) + '/../capistrano-eden' if ! defined?(CapistranoEden)

CapistranoEden.with_configuration do

  namespace :memcached do

    ### start/stop/restart
    [:start, :stop, :restart, :status].each do |t|
        desc "(memcached.rb) sudo /etc/init.d/memcached #{t}"
        task t, :roles => :memcache, :except => { :no_release => true } do
          run "#{sudo} /etc/init.d/memcached #{t}", :pty => true
        end
    end

  end # namespace

end


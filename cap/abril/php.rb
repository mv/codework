require File.dirname(__FILE__) + '/../capistrano-eden' if ! defined?(CapistranoEden)

CapistranoEden.with_configuration do

  namespace :deploy do

    desc "(php.rb) restart: NO"
    task :restart do
      # No need to restart the web server.
    end

    desc "(php.rb) finalize_update: NO"
    task :finalize_update do
      # No need to make any extra symlinks.
    end

  end # namespace

end


require File.dirname(__FILE__) + '/../capistrano-eden' if ! defined?(CapistranoEden)

CapistranoEden.with_configuration do

  namespace :gems do

    desc "(gems.rb) Install gems on the remote server."
    task :install, :roles => :app do
      rails_env = fetch(:rails_env, "production")
      run "cd #{current_release} && #{sudo} rake gems:install RAILS_ENV=#{rails_env}", :pty => true
    end
    after "deploy:update_code", "gems:install"

  end # namespace

end


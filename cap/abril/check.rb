require File.dirname(__FILE__) + '/../capistrano-eden' if ! defined?(CapistranoEden)

CapistranoEden.with_configuration do

  namespace :check do

    desc '(check-rails2.rb) Check Rails2 before symlink/startup.'
    task :rails2, :roles => :app, :except => { :no_release => true } do
      on_rollback { run "rm -rf #{latest_release}; true" }

      run "cd #{latest_release} && RAILS_ENV=#{rails_env} ./script/runner 'puts Rails.env'"

    end

    desc '(check-rails3.rb) Check Rails3 before symlink/startup.'
    task :rails3, :roles => :app, :except => { :no_release => true } do
      on_rollback { run "rm -rf #{latest_release}; true" }

      run "cd #{latest_release} && RAILS_ENV=#{rails_env} bundle exec rails runner 'puts Rails.env'"

    end

  end # namespace

end

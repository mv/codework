require File.dirname(__FILE__) + '/../capistrano-eden' if ! defined?(CapistranoEden)

CapistranoEden.with_configuration do

  namespace :deploy do

    desc '(site-reference.rb ) Alexandria site-reference'
    task :do_site_reference do

      if !exists?(:structure_path)
        abort 'You must specify the correct destination using the "set :structure_path" command.'
      end

      run "mkdir -p #{structure_path} && chmod g+w #{structure_path}"
      run "rm -rf #{latest_release}/structure && ln -nsf  #{structure_path}/current #{latest_release}/structure"

    end
    after "deploy:symlink", "deploy:do_site_reference"

  end # namespace


end


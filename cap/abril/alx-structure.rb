require File.dirname(__FILE__) + '/../capistrano-eden' if ! defined?(CapistranoEden)

CapistranoEden.with_configuration do

  namespace :deploy do

    desc '(alx-structure.rb) Alexandria site-structure deploy.'
    task :structure do

      # checking....
      [ :structure_path, :structure_repos, :structure_branch ].each do |item|
        if !exists?( item )
          abort "You must specify 'set :#{item}' in deploy.rb. See README."
        end
      end

      # Custom branch/tag ?
      set :st_branch, ENV['STRUCTURE'] || :structure_branch || 'master'

      # structure clone
      # symlink inside site-reference
      run <<-CMD
        if [ -d #{structure_path}/.git ] ;
        then echo "Structure: git found...";
        else echo "Cloning structure:" &&
             git clone --depth 1 #{structure_repos} #{structure_path} &&
             cd #{structure_path} && git checkout -t origin/#{st_branch} ;
        fi ;
        ln -nsf #{structure_path} #{latest_release}/structure
      CMD

    end
    after "deploy:symlink" , "deploy:structure"


    desc '(alx-structure.rb) Alexandria structure RESET.'
    task :structure_reset do

      # Custom branch/tag ?
      set :st_branch, ENV['STRUCTURE'] || :structure_branch || 'master'

      # structure clone
      # symlink inside site-reference
      run <<-CMD
        if [ -d #{structure_path}/.git ] ;
        then echo "Resetting structure:" && cd #{structure_path} && git reset --hard && git clean -d -x -f;
        else echo "Structure: git NOT FOUND";
        fi ;
      CMD

    end

    desc '(alx-structure.rb) Update structure dir'
    task :update_structure do
      run <<-CMD
        cd #{structure_path} &&
        git fetch &&
        git checkout -f `git rev-parse origin/#{structure_branch}`
      CMD
    end

  end # namespace

end


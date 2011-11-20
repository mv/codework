# Role scoping method.
def with_role(role, &block)
  original, ENV['HOSTS'] = ENV['HOSTS'], find_servers(:roles =>role).map{|d| d.host}.join(",")
  begin
    yield
  ensure
    ENV['HOSTS'] = original 
  end
end

#set :stages, %w(stag production testing)
#require 'capistrano/ext/multistage'

# =============================================================================
# SSH OPTIONS
# =============================================================================
#default_run_options[:pty] = true
#ssh_options[:paranoid] = false
#ssh_options[:verbose] = :debug
#ssh_options[:forward_agent] = true

# =============================================================================
# BASIC CONFIGURATION
# =============================================================================
set :application  , "bbs"
set :scm          , :git
set :repository   , "git@git.webcointernet.com:/repos/blogblogs"
set :user         , "bbs"
set :deploy_to    , "/webco/app/#{application}"
set :releases_path, "#{deploy_to}/releases"
set :current_path , "#{deploy_to}/current"
#set :branch       , "rails21 origin/rails21"
#set :branch       , "v3      origin/v3"

# =============================================================================
# PRODUCTION SERVERS
# =============================================================================
role :prod , "dbms02.webcointernet.com", "wsbb01.webcointernet.com", "wsbb02.webcointernet.com", "wsbb03.webcointernet.com", "wgbb01.webcointernet.com", "wgbb02.webcointernet.com", "wgbb03.webcointernet.com", "asimov01.webcointernet.com", "asimov02.webcointernet.com", "api01.webcointernet.com", "api02.webcointernet.com"
role :db   , "dbms02.webcointernet.com", :primary => true
role :dna  , "dna01.webcointernet.com"
role :idx  , "async02.webcointernet.com"
role :web  , "wsbb01.webcointernet.com", "wsbb02.webcointernet.com", "wsbb03.webcointernet.com", "wgbb01.webcointernet.com", "wgbb02.webcointernet.com", "wgbb03.webcointernet.com", "api01.webcointernet.com", "api02.webcointernet.com"
role :ws   , "wsbb01.webcointernet.com", "wsbb02.webcointernet.com", "wsbb03.webcointernet.com"
role :api  , "api01.webcointernet.com", "api02.webcointernet.com"
role :web1 , "wsbb01.webcointernet.com"
role :web2 , "wsbb02.webcointernet.com"
role :web3 , "wsbb03.webcointernet.com"
role :wid1 , "wgbb01.webcointernet.com"
role :wid2 , "wgbb02.webcointernet.com"
role :wid3 , "wgbb03.webcointernet.com"
role :api1 , "api01.webcointernet.com"
role :api2 , "api02.webcointernet.com"
role :robo1, "asimov01.webcointernet.com"
role :robo2, "asimov02.webcointernet.com"
role :cache, "wsbb03.webcointernet.com", "wgbb03.webcointernet.com", "api01.webcointernet.com", "api02.webcointernet.com"

# =============================================================================
# STAGING SERVER
# =============================================================================
role :stage, "stag02.webcointernet.com"

# =============================================================================
# DEVELOPMENT SERVER - WEBCO02
# =============================================================================
role :dev, "172.16.20.40"

# =============================================================================
# COMMON TASKS (default roles)
# =============================================================================
namespace :common do

task :env do
  run "env"
end

desc "BlogBlogs: View production log from all servers"
task :tail_log, :roles => :web do
  stream "tail -f #{current_path}/log/production.log"
end

desc "BlogBlogs: View production log from api servers"
task :tail_log_api, :roles => :api do
  stream "tail -f #{current_path}/log/production.log"
end

desc "BlogBlogs: View production log from web servers"
task :tail_log_ws, :roles => :ws do
  stream "tail -f #{current_path}/log/production.log"
end

  task :zone_status do
    puts "ZONEID    NPROC  SWAP   RSS MEMORY      TIME  CPU ZONE"
    run "/usr/bin/prstat -Z -n 1 1 1 | /usr/xpg4/bin/grep gpuac"
    run "/usr/bin/ps -ef | /usr/xpg4/bin/grep http | /usr/bin/wc"
    run "/usr/bin/ps -ef | /usr/xpg4/bin/grep ruby | /usr/bin/wc"
  end

  task :info do
    run <<-CMD
      /usr/bin/hostname &&
      /usr/bin/zonename &&
      /usr/bin/uptime &&
      /opt/local/bin/svn info #{deploy_to}/trunk
    CMD
  end

  task :bbs_db_reset do
    verify = Capistrano::CLI.ui.ask("Are you sure? [Yes or No]")
    if verify == "Yes" || verify == "yes"
      run <<-CMD
        cd #{deploy_to}/current &&
        #{rake_path}/rake db:drop:all &&
        #{rake_path}/rake db:create &&
        #{rake_path}/rake db:migrate &&
        #{rake_path}/rake utils:load
      CMD
    else
      puts "This can't be done without confirmation."
    end
  end

  task :bbs_db_migrate do
    verify = Capistrano::CLI.ui.ask("Are you sure? [Yes or No]")
    if verify == "Yes" || verify == "yes"
      run <<-CMD
        cd #{deploy_to}/current &&
        #{rake_path}/rake db:migrate
      CMD
    else
      puts "This can't be done without confirmation."
    end
  end
  
  task :setup_release do
    run <<-CMD
      mkdir -p #{deploy_to}/releases &&
      rm -rf #{deploy_to}/blogblogs
    CMD
    checkout_code
    prepare_release
    prepare_config_files
  end

  task :update_release do
    update_code
    prepare_release
    prepare_config_files
  end

  task :prepare_release do
    set :new_release, Time.now.strftime("%Y%m%d%H%M")
    run <<-CMD
      cp -R #{deploy_to}/blogblogs #{deploy_to}/releases/#{new_release} &&
      rm -f #{deploy_to}/current &&
      ln -s #{deploy_to}/releases/#{new_release} #{deploy_to}/current
    CMD
  end

  task :checkout_code do
    run <<-CMD
         cd  #{deploy_to}                                                             \
         && #{git_path}/git clone -q ssh://git@git.webcointernet.com/repos/blogblogs  \
         && cd blogblogs                                                              \
         && #{git_path}/git checkout stable
    CMD
      # novo bbs: de v3 para MASTER
      #  && cd blogblogs  \
      #  && #{git_path}/git checkout master
  end

  task :update_code do
    run <<-CMD
        cd #{deploy_to}/blogblogs       ;  \
        #{git_path}/git checkout stable ;  \
        #{git_path}/git pull
    CMD
#    run "[ -f #{deploy_to}/blogblogs/config/environments/localhost.rb ] && /bin/rm #{deploy_to}/blogblogs/config/environments/localhost.rb"
#    run "[ -f #{deploy_to}/blogblogs/lib/cache_faker.rb               ] && /bin/rm #{deploy_to}/blogblogs/lib/cache_faker.rb"
  end

  task :prepare_config_files do
    run <<-CMD
      cp #{deploy_to}/config/database.yml             #{deploy_to}/current/config/database.yml        && \
      cp #{deploy_to}/config/dna.yml                  #{deploy_to}/current/config/dna.yml             && \
      cp #{deploy_to}/config/mongrel_cluster.yml      #{deploy_to}/current/config/mongrel_cluster.yml && \
      cp #{deploy_to}/config/thin_cluster.yml         #{deploy_to}/current/config/thin_cluster.yml    && \
      cp #{deploy_to}/config/memcached.yml            #{deploy_to}/current/config/memcached.yml       && \
      cp #{deploy_to}/config/heyho-search.yml         #{deploy_to}/current/config/heyho-search.yml    && \
      cp #{deploy_to}/config/heyho-search-fields.yml  #{deploy_to}/current/config/heyho-search-fields.yml
    CMD
  end

  task :link_shared_public do
    run "rm -rf #{deploy_to}/current/public"
    run "ln -s /shared/bbs/blogblogs/public #{deploy_to}/current/public"
  end
  
  task :copy_public_stub do
    run "cp -Rp #{deploy_to}/current/public_stub/* /shared/bbs/blogblogs/public | exit 0"
  end

  task :create_dirs do
      sudo "ln -s /webco/logs/bbs #{current_path}/log"
      run "mkdir #{current_path}/tmp"
      run "mkdir #{current_path}/tmp/pids"
      run "touch #{current_path}/log/blogblogs-utilities.log"
  end

  task :prepare_public, :roles => :prod do
    with_role :prod do
      common.link_shared_public
      common.copy_public_stub
    end
  end

  task :mongrel_cluster_start do
    # run "cd #{deploy_to}/current && #{mongrel_path}/mongrel_rails cluster::start --config #{deploy_to}/current/config/mongrel_cluster.yml"
    sudo "/etc/init.d/mongrel start"
    run "/webco/scripts/watch_it.pl --enable"
  end

  task :mongrel_cluster_stop do
    run "/webco/scripts/watch_it.pl --disable"
    sudo "/etc/init.d/mongrel stop"
    # run "cd #{deploy_to}/current && #{mongrel_path}/mongrel_rails cluster::stop --config #{deploy_to}/current/config/mongrel_cluster.yml"
  end

  task :mongrel_cluster_restart do
    run "/webco/scripts/watch_it.pl --disable"
    run "cd #{deploy_to}/current && #{mongrel_path}/mongrel_rails cluster::restart --config #{deploy_to}/current/config/mongrel_cluster.yml"
    run "/webco/scripts/watch_it.pl --enable"
  end

  task :mongrel_cluster_status do
    run "#{mongrel_path}/mongrel_rails cluster::status --config #{deploy_to}/current/config/mongrel_cluster.yml"
  end

  task :mongrel_pid_clean do
    run "rm -f #{deploy_to}/current/tmp/pids/mongrel*.pid"
  end

  task :check_mongrels_running do
    run "echo -n 'Mongrels running: ' && ps -ef | grep mongrel | grep bbs | grep -v grep | wc -l"
  end


  task :thin_cluster_start do
    run "cd #{current_path} && #{thin_path}/thin start   -C #{deploy_to}/current/config/thin_cluster.yml"
    run "/webco/scripts/watch_it.pl --enable"
  end

  task :thin_cluster_stop do
    run "/webco/scripts/watch_it.pl --disable"
    run "cd #{current_path} && #{thin_path}/thin stop -f -C #{deploy_to}/current/config/thin_cluster.yml"
  end

  task :thin_cluster_restart do
    run "/webco/scripts/watch_it.pl --disable"
    run "cd #{current_path} && #{thin_path}/thin restart -C #{deploy_to}/current/config/thin_cluster.yml"
    run "/webco/scripts/watch_it.pl --enable"
  end

  task :apache_start do
    sudo "/usr/sbin/svcadm enable apache"
  end

  task :apache_stop do
    sudo "/usr/sbin/svcadm disable apache"
  end

  task :apache_restart do
    sudo "/usr/sbin/svcadm restart apache"
  end

  task :heyho_search_start do
    sudo "/etc/init.d/heyho-server-bbs start"
  end

  task :heyho_search_stop, :on_error => :continue do
    sudo "/etc/init.d/heyho-server-bbs stop"
  end

#  task :heyho_search_link_index do
#      sudo "ln -s /webco/app/heyho/bbs #{current_path}/index"
#  end

  task :memcache_start do
    sudo "/etc/init.d/memcached-bbs-app start"
    sudo "/etc/init.d/memcached-bbs-session start"
  end

  task :memcache_stop do
    sudo "/etc/init.d/memcached-bbs-app stop"
    sudo "/etc/init.d/memcached-bbs-session stop"
  end

end

# =============================================================================
# DEVELOPMENT TASKS (scoped to dev)
# =============================================================================
namespace :dev do

    task :env, :roles => :dev do
      with_role :dev do
         common.env
       end
    end

  task :info, :roles => :dev do
    with_role :dev do
      common.info
    end
  end

  task :setup, :roles => :dev do
    with_role :dev do
      set :git_path, "/usr/local/bin"
      common.setup_release
      common.link_shared_public
      common.copy_public_stub
    end
  end

  task :deploy, :roles => :dev do
    set :mongrel_path, "/usr/local/bin"
    set :git_path, "/usr/local/bin"
    stop
    with_role :dev do
      common.update_release
    end
    with_role :dev do
      common.link_shared_public
    end
    with_role :dev do
      common.copy_public_stub
    end
    run "mkdir #{current_path}/log"
    run "mkdir #{current_path}/tmp"
    run "mkdir #{current_path}/tmp/pids"
    start
  end

  task :start, :roles => :dev do
    with_role :dev do
      set :mongrel_path, "/usr/local/bin"
#       common.heyho_search_start
#      common.apache_start
      dev.mongrel_cluster_start
    end
  end

  task :stop, :roles => :dev do
    with_role :dev do
      set :mongrel_path, "/usr/local/bin"
      dev.mongrel_cluster_stop
      common.check_mongrels_running
#      common.apache_stop
#      common.heyho_search_stop
    end
  end

  task :prepare_public, :roles => :dev do
    with_role :dev do
      common.link_shared_public
      common.copy_public_stub
    end
  end

  task :bbs_db_reset, :roles => :dev do
    with_role :dev do
      set :rake_path, "/usr/local/bin"
      common.bbs_db_reset
    end
  end

  task :bbs_db_migrate, :roles => :dev do
    with_role :dev do
      set :rake_path, "/usr/local/bin"
      common.bbs_db_migrate
    end
  end

  task :mongrel_cluster_start, :roles => :dev do
    with_role :dev do
#      common.mongrel_cluster_start
    sudo "/etc/init.d/mongrel-bbs start"
    run "/webco/scripts/watch_it.pl --enable"
    end
  end

  task :mongrel_cluster_stop, :roles => :dev , :on_error => :continue do  
    with_role :dev do
#      common.mongrel_cluster_stop
    run "/webco/scripts/watch_it.pl --disable"
    sudo "/etc/init.d/mongrel-bbs stop"
    end
  end

  task :mongrel_cluster_restart, :roles => :dev do
    dev.mongrel_cluster_stop
    dev.mongrel_cluster_start
  end

  task :heyho_search_start, :roles => :dev do
    with_role :dev do
      common.heyho_search_start
   end
  end

#  task :heyho_search_stop, :roles => :dev do
#  task :heyho_search_stop, :roles => :dev, :on_error => :continue do  
  task :heyho_search_stop, :roles => :dev do
    with_role :dev do
      common.heyho_search_stop
#      sudo "/etc/init.d/heyho_search stop | exit 0"
    end
  end

  task :apache_start, :roles => :dev do
    with_role :dev do
      common.apache_start
   end
  end

  task :apache_stop, :roles => :dev do
    with_role :dev do
      common.apache_stop
    end
  end

  task :memcache_start, :roles => :dev do
    with_role :dev do
      common.memcache_start
    end
  end

  task :memcache_stop, :roles => :dev do
    with_role :dev do
      common.memcache_stop
    end
  end

end

# =============================================================================
# STAGING TASKS (scoped to stage)
# =============================================================================
namespace :stage do

    task :env, :roles => :stage do
      with_role :stage do
         common.env
       end
    end

  task :info, :roles => :stage do
    with_role :stage do
      common.info
    end
  end

  task :setup, :roles => :stage do
    with_role :stage do
      set :git_path, "/opt/local/bin"
      common.setup_release
      common.link_shared_public
      common.copy_public_stub
      common.create_dirs
    end
  end

  task :deploy, :roles => :stage do
    set :git_path, "/opt/local/bin"
    set :mongrel_path, "/opt/local/bin"
    set :thin_path, "/opt/local/bin"
    stop
    with_role :stage do
      common.update_release
    end
    with_role :stage do
      common.link_shared_public
    end
    with_role :stage do
      common.copy_public_stub
    end
    with_role :stage do
      common.create_dirs
    end
#    with_role :stage do
#      stage.heyho_search_link_index
#    end
    start
  end

  task :start, :roles => :stage do
    with_role :stage do
      set :mongrel_path, "/opt/local/bin"
      set :thin_path, "/opt/local/bin"
      common.heyho_search_start
#      common.apache_start
#      stage.mongrel_cluster_start
      common.thin_cluster_start
    end
  end

  task :stop, :roles => :stage do
    with_role :stage do
      set :mongrel_path, "/opt/local/bin"
      set :thin_path, "/opt/local/bin"
#      stage.mongrel_cluster_stop
      common.thin_cluster_stop
#      common.apache_stop
      common.heyho_search_stop
    end
  end

  task :prepare_public, :roles => :stage do
    with_role :stage do
      common.link_shared_public
      common.copy_public_stub
    end
  end

  task :bbs_db_reset, :roles => :stage do
    with_role :stage do
      set :rake_path, "/opt/local/bin"
      common.bbs_db_reset
      run <<-CMD
        cd #{deploy_to}/current &&
        #{rake_path}/rake db:fixtures:load
      CMD
    end
  end

  task :bbs_db_migrate, :roles => :stage do
    with_role :stage do
      set :rake_path, "/opt/local/bin"
      common.bbs_db_migrate
    end
  end

  task :mongrel_cluster_start, :roles => :stage do
    with_role :stage do
    run "#{mongrel_path}/mongrel_rails cluster::start --config #{deploy_to}/current/config/mongrel_cluster.yml"
#      common.mongrel_cluster_start
    run "/webco/scripts/watch_it.pl --enable"
    end
  end

  task :mongrel_cluster_stop, :roles => :stage do
    with_role :stage do
    run "/webco/scripts/watch_it.pl --disable"
    run "#{mongrel_path}/mongrel_rails cluster::stop --config #{deploy_to}/current/config/mongrel_cluster.yml"
#      common.mongrel_cluster_stop
    end
  end

  task :mongrel_cluster_restart, :roles => :stage do
    stage.mongrel_cluster_stop
    stage.mongrel_cluster_start
  end

  task :thin_cluster_start, :roles => :stage do
    with_role :stage do
      common.thin_cluster_start
    end
  end

  task :thin_cluster_stop, :roles => :stage do
    with_role :stage do
      common.thin_cluster_stop
    end
  end

  task :thin_cluster_restart, :roles => :stage do
    stage.thin_cluster_stop
    stage.thin_cluster_start
  end
  
  task :heyho_search_start, :roles => :stage do
    with_role :stage do
      common.heyho_search_start
    end
  end

  task :heyho_search_stop, :roles => :stage do
    with_role :stage do
      common.heyho_search_stop
    end
  end

  task :heyho_search_link_index, :roles => :stage do
    with_role :stage do
      sudo "ln -s /webco/app/heyho_search_bbs #{current_path}/index"
    end
  end

  task :apache_start, :roles => :stage do
    with_role :stage do
      common.apache_start
    end
  end

  task :apache_stop, :roles => :stage do
    with_role :stage do
      common.apache_stop
    end
  end

  task :memcache_start, :roles => :stage do
    with_role :stage do
      common.memcache_start
    end
  end

  task :memcache_stop, :roles => :stage do
    with_role :stage do
      common.memcache_stop
    end
  end

end

# =============================================================================
# PRODUCTION TASKS (scoped to stage)
# =============================================================================
namespace :prod do

desc "BlogBlogs: View production log from all servers"
 task :tail_log, :roles => :web do
  stream "tail -f #{current_path}/log/production.log | grep Complet"
end

  task :info, :roles => :prod do
    with_role :prod do
      common.info
    end
  end

  task :env, :roles => :prod do
    with_role :prod do
      common.env
    end
  end

  task :tail_log, :roles => :prod do
    with_role :web do
      common.tail_log
    end
  end

  task :tail_log_api, :roles => :prod do
    with_role :api do
      common.tail_log_api
    end
  end

  task :tail_log_ws, :roles => :prod do
    with_role :ws do
      common.tail_log_ws
    end
  end


  task :hostname, :roles => :prod do
    with_role :prod do
      run "hostname"
    end
  end

  task :setup, :roles => :prod do
    set :git_path, "/opt/local/bin"
    with_role :prod do
      common.setup_release
    end
    with_role :prod do
      common.link_shared_public
    end
    with_role :db do
      common.copy_public_stub
    end
    with_role :prod do
      common.create_dirs
    end
  end

  task :deploy, :roles => :prod do
    set :git_path, "/opt/local/bin"
    set :mongrel_path, "/opt/local/bin"
    set :thin_path, "/opt/local/bin"
    stop
    with_role :prod do
      common.update_release
    end
    with_role :prod do
      common.link_shared_public
    end
    with_role :db do
      common.copy_public_stub
    end
    with_role :prod do
      common.create_dirs
    end
#    with_role :idx do
#      common.heyho_search_link_index
#    end
    start
  end

  task :start, :roles => :prod do
    set :mongrel_path, "/opt/local/bin"
    set :thin_path, "/opt/local/bin"
    with_role :idx do
      common.heyho_search_start
    end
#    with_role :web do
#      common.apache_start
#      common.mongrel_cluster_start
#      common.thin_cluster_start
#    end
    with_role :web1 do
      common.thin_cluster_start
    end
    with_role :web2 do
      common.mongrel_cluster_start
    end
    with_role :web3 do
      common.mongrel_cluster_start
    end
    with_role :wid1 do
      common.thin_cluster_start
    end
    with_role :wid2 do
      common.mongrel_cluster_start
    end
    with_role :wid3 do
      common.mongrel_cluster_start
    end
    with_role :api1 do
      common.mongrel_cluster_start
    end
    with_role :api2 do
      common.mongrel_cluster_start
    end
end

  task :stop, :roles => :prod do
    set :mongrel_path, "/opt/local/bin"
    set :thin_path, "/opt/local/bin"
#    with_role :web do
#      common.mongrel_cluster_stop
#      common.thin_cluster_stop
#      common.apache_stop
#    end
    with_role :web1 do
      common.thin_cluster_stop
    end
    with_role :web2 do
      common.mongrel_cluster_stop
    end
    with_role :web3 do
      common.mongrel_cluster_stop
    end
    with_role :wid1 do
      common.thin_cluster_stop
    end
    with_role :wid2 do
      common.mongrel_cluster_stop
    end
    with_role :wid3 do
      common.mongrel_cluster_stop
    end
    with_role :api1 do
      common.mongrel_cluster_stop
    end
    with_role :api2 do
      common.mongrel_cluster_stop
    end
    with_role :idx do
      common.heyho_search_stop
    end
  end

  task :mongrel_cluster_refresh, :roles => :prod do
    with_role :web1 do
      common.mongrel_cluster_stop
      common.mongrel_cluster_stop
      common.mongrel_pid_clean
      common.mongrel_cluster_start
    end
    sleep 60
    with_role :web2 do
      common.mongrel_cluster_stop
      common.mongrel_cluster_stop
      common.mongrel_pid_clean
      common.mongrel_cluster_start
    end 
  end
  

  task :prepare_public, :roles => :prod do
    with_role :prod do
      common.link_shared_public
      common.copy_public_stub
    end
  end

  task :bbs_db_reset, :roles => :prod do
    with_role :db do
      common.bbs_db_reset
    end
  end

  task :bbs_db_migrate, :roles => :prod do
    with_role :db do
      common.bbs_db_migrate
    end
  end

  task :mongrel_cluster_start, :roles => :prod do
    with_role :web do
      common.mongrel_cluster_start
    end
  end

  task :mongrel_cluster_stop, :roles => :prod do
    with_role :web do
      common.mongrel_cluster_stop
    end
  end

  task :mongrel_cluster_restart, :roles => :prod do
    prod.mongrel_cluster_stop
    prod.mongrel_cluster_start
  end

  task :thin_cluster_start, :roles => :prod do
    with_role :web do
      common.thin_cluster_start
    end
  end

  task :thin_cluster_stop, :roles => :prod do
    with_role :web do
      common.thin_cluster_stop
    end
  end

  task :thin_cluster_restart, :roles => :prod do
    prod.thin_cluster_stop
    prod.thin_cluster_start
  end
  
  task :heyho_search_start, :roles => :prod do
    with_role :idx do
      common.heyho_search_start
    end
  end

  task :heyho_search_stop, :roles => :prod do
    with_role :idx do
      common.heyho_search_stop
    end
  end

  task :apache_start, :roles => :prod do
    with_role :web do
      common.apache_start
    end
  end

  task :apache_stop, :roles => :prod do
    with_role :web do
      common.apache_stop
    end
  end

  task :memcache_start, :roles => :prod do
    with_role :cache do
      common.memcache_start
    end
  end

  task :memcache_stop, :roles => :prod do
    with_role :cache do
      common.memcache_stop
    end
  end

end

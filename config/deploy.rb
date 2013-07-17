require "bundler/capistrano"

set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"

set :application, "Crowddesign"
#set :repository,  "ubuntu@ec2-54-245-143-145.us-west-2.compute.amazonaws.com:/home/ubuntu/repository/crowddesign.git"
set :repository,  "ssh://crowddesign@orchid-research.cs.uiuc.edu:3020/home/crowddesign/repository/crowddesign.git"

set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

#set :ssh_options, {:forward_agent => true}
set :ssh_options, {:port => 3020}
set :use_sudo, false
#set :deploy_to, "/home/ubuntu/www/RailsApp/#{application}"
set :deploy_to, "/home/crowddesign/www/RailsApp/#{application}"
#set :user, "ubuntu"
set :user, "crowddesign"

set :rvm_ruby_string, :local               # use the same ruby as used locally for deployment
set :rvm_autolibs_flag, "read-only"        # more info: rvm help autolibs

before 'deploy:setup', 'rvm:install_rvm'   # install RVM
before 'deploy:setup', 'rvm:install_ruby'  # install Ruby and create gemset, OR:
#before 'deploy:setup', 'rvm:create_gemset' # only create gemset

require "rvm/capistrano"

role :web, "orchid-research.cs.uiuc.edu"                          # Your HTTP server, Apache/etc
role :app, "orchid-research.cs.uiuc.edu"                          # This may be the same as your `Web` server
role :db,  "orchid-research.cs.uiuc.edu", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
 task :start do ; end
 task :stop do ; end
 task :restart, :roles => :app, :except => { :no_release => true } do
   run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
 end
end


set :shared_database_path, "#{shared_path}/databases"
namespace :sqlite3 do
  desc "Generate a database configuration file"
  task :build_configuration, :roles => :db do
    db_options = {
      "adapter"  => "sqlite3",
      "database" => "#{shared_database_path}/production.sqlite3"
    }
    config_options = {"production" => db_options}.to_yaml
    put config_options, "#{shared_database_path}/sqlite_config.yml"
  end
 
  desc "Links the configuration file"
  task :link_configuration_file, :roles => :db do
    run "ln -nsf #{shared_database_path}/sqlite_config.yml #{release_path}/config/database.yml"
  end
 
  desc "Make a shared database folder"
  task :make_shared_folder, :roles => :db do
    run "mkdir -p #{shared_database_path}"
  end
end

after "deploy:setup", "sqlite3:make_shared_folder"
after "deploy:setup", "sqlite3:build_configuration"
 
after "deploy:assets:symlink", "sqlite3:link_configuration_file"


set :shared_config_path, "#{shared_path}/config"
namespace :deploy do
  desc "Make a shared configuration folder"
  task :make_shared_config_folder, :roles => :app do
    run "mkdir -p #{shared_config_path}"
    run "touch #{shared_config_path}/application.yml"
  end


  desc "Links the application configuration file"
  task :link_app_configuration_file, :roles => :app do
    run "ln -nsf #{shared_config_path}/application.yml #{release_path}/config/application.yml"
  end

end

after "deploy:setup", "deploy:make_shared_config_folder"
after "deploy:assets:symlink", "deploy:link_app_configuration_file"

namespace :deploy do
  desc "Links the turkee configuration file"
  task :link_turkee_configuration_file, :roles => :app do
    run "ln -nsf #{shared_config_path}/turkee.rb #{release_path}/config/initializers/turkee.rb"
  end
end
after "deploy:assets:symlink", "deploy:link_turkee_configuration_file"

# Paperclip
namespace :deploy do
  desc "build missing paperclip styles"
  task :build_missing_paperclip_styles, :roles => :app do
    run "cd #{release_path}; RAILS_ENV=production bundle exec rake paperclip:refresh:missing_styles"
  end
end

after("deploy:update_code", "deploy:build_missing_paperclip_styles")

#coding: utf-8
require "bundler/capistrano"
require "rvm/capistrano"
require "whenever/capistrano"

set :rvm_ruby_string, "2.1.1@rails211403"
#set :rvm_bin_path, "/usr/local/rvm/bin"
set :normalize_asset_timestamps, false
set :application, "jokenewsworld"
set :repository,  "xxx.git"
set :branch, "master"
set :deploy_to, "xxx"
set :scm, :git
#set :scm, :subversion
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "localhost"                          # Your HTTP server, Apache/etc
role :app, "localhost"                          # This may be the same as your `Web` server
role :db,  "localhost", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

set :current_path, "#{deploy_to}/current"
set :user, "xxx"
set :password, "xxx"
#set :unicorn_config, "#{current_path}/config/unicorn.rb"
#set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"
#set :unicorn_config, "#{current_path}/config/unicorn.rb"
#set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
require 'capistrano/server_definition'
require 'capistrano/role'
class Capistrano::Configuration
  def role_names_for_host(host)
    roles.map {|role_name, role| role_name if role.include?(host) }.compact || []
  end
end

 namespace :deploy do
   before "deploy:restart", "deploy:update_files"
   after "deploy:update_files", "deploy:update_crontab"
   #before "deploy:restart", "deploy:move_files"

   task :update_files do
     run  "cd #{current_path} && chmod 755 #{current_path} #{current_path}/public && /bin/cp -r /deploy_files/* #{current_path} "
   end


   desc "Update the crontab file"
   task :update_crontab do
     run "cd #{current_path} && bundle exec whenever --update-crontab #{application}"
   end

   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
   	run "touch #{File.join(current_path,'tmp','restart.txt')}"   
   end
 end

#namespace :deploy do
#  task :start, :roles => :app, :except => { :no_release => true } do
#      run "cd #{current_path} && RAILS_ENV=production bundle exec unicorn_rails -c #{unicorn_config} -D"
#  end
#
#  task :stop, :roles => :app, :except => { :no_release => true } do
#      run "if [ -f #{unicorn_pid} ]; then kill -QUIT `cat #{unicorn_pid}`; fi"
#  end
#	
# task :restart, :roles => :app, :except => { :no_release => true } do
#    # 用USR2信号来实现无缝部署重启
#      run "if [ -f #{unicorn_pid} ]; then kill -s USR2 `cat #{unicorn_pid}`; fi"
#  end
#end

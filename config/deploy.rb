# Encoding: utf-8

set :user,    "root"
set :appname, "tick-tock"

require "capistrano/af83"
load "af83/info"

# Use the capistrano rules for precompiling assets with the Rails assets
# pipeline on deploys.
# set :public_children, %w(images)
load "deploy/assets"
# OR you can choose our improved version of this task:
# load "af83/deploy/assets"

# load "af83/thin"
load "af83/unicorn"

# load "af83/custom_maintenance_page"
# load "af83/es"
load "af83/mongoid"
# load "af83/database"
# load "af83/resque"
# load "af83/js_routes"

#require "bundler/capistrano"
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "rvm/capistrano"

default_run_options[:pty] = true

set :application, "116.255.196.14:2212"
set :repository,  "https://github.com/jasl/tick-tock.git"
set :scm, :git
set :branch, "master"
ssh_options[:forward_agent] = true

set :deploy_to, "/var/www/#{appname}/"
set :use_sudo, false
# set :copy_exclude, %w".git spec"

set :rvm_ruby_string, '1.9.3'
set :rvm_type, :system
#role :web, "tick-tock.net"                          # Your HTTP server, Apache/etc
#role :app, "tick-tock.net"                          # This may be the same as your `Web` server
#role :db,  "tick-tock.net", :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"

server "116.255.196.14:2212", :app, :web, :db, :primary => true

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end


# Encoding: utf-8
require "capistrano_colors"
require "sushi/ssh"
require "bundler/capistrano"
require "rvm/capistrano"

# Set remote server user
set :user, "root"
set :runner, "www"

# Fix RVM
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

default_run_options[:pty] = true

set :application, "tick-tock"
set :repository,  "https://github.com/jasl/tick-tock.git"
set :scm, :git
set :branch, "master"
ssh_options[:forward_agent] = true

set :deploy_to, "/home/www/#{application}/"
set :use_sudo, false
set :copy_exclude, %w".git spec"

# set :rvm_ruby_string, '1.9.3'
set :rvm_type, :system

server "116.255.196.14:2212", :app, :web, :db, :primary => true

namespace :mongoid do
  desc "Create MongoDB indexes"
  task :index do
    run "cd #{current_path} && bundle exec rake db:mongoid:create_indexes RAILS_ENV=#{rails_env} ", :once => true
  end

  desc "Clean all data"
  task :drop do
    run "cd #{current_path} && bundle exec rake db:mongoid:drop RAILS_ENV=#{rails_env}", :once => true
  end
  after "deploy:update", "mongoid:index"
end

namespace :demo do
  desc "Create demo user"
  task :create do
    run "cd #{current_path} && bundle exec rake db:seed RAILS_ENV=#{rails_env}", :once => true
  end

  after "mongoid:index", "demo:create"
end

depend :remote, :command, "bundle"

namespace :deploy do
  desc "Start unicorn"
  task :start, :roles => :app do
    run "cd #{current_path} && find -exec chown #{runner} {} \\;"
    run "cd #{current_path}/log && find -exec chown #{runner} {} \\;"
    run "cd #{current_path} && bundle exec unicorn_rails -c config/unicorn.rb -E #{rails_env} -D"
  end

  desc "Stop unicorn"
  task :stop, :roles => :app do
    set :unicorn_pidfile, "#{shared_path}/pids/unicorn.pid"
    run "if [ -e #{unicorn_pidfile} ] ; then kill -QUIT `cat #{unicorn_pidfile}` ; fi"
  end

  desc "Restart unicorn"
  task :restart, :roles => :app  do
    #set :unicorn_pid, capture("cat #{shared_path}/pids/unicorn.pid").chomp
    #run "kill -USR2 #{unicorn_pid}"
    #sleep 1
    #run "kill -QUIT #{unicorn_pid}"
    set :unicorn_pidfile, "#{shared_path}/pids/unicorn.pid"
    run "cd #{current_path} && find -exec chown #{runner} {} \\;"
    run "cd #{current_path}/log && find -exec chown #{runner} {} \\;"
    run "if [ -e #{unicorn_pidfile} ] ; then kill -QUIT `cat #{unicorn_pidfile}` ; fi"
    sleep 1
    run "cd #{current_path} && bundle exec unicorn_rails -c config/unicorn.rb -E #{rails_env} -D"
  end
end

#task :deploy, :hosts => "root@116.255.196.14:2212" do
#  run "ls -x1 /usr/lib | grep -i xml"
#end

# assets:precompile fails need to run 'chcon -t texrel_shlib_t' for every v8.so
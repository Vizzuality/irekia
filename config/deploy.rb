require 'capistrano/ext/multistage'
require "bundler/capistrano"

set :stages, %w(staging production)
set :default_stage, "staging"

default_run_options[:pty] = true

set :application, 'irekia'

set :scm, :git
#set :git_shallow_clone, 1
set :deploy_via, :remote_cache
set :scm_user, 'ubuntu'
set :use_sudo, false
set :repository, "git@github.com:Vizzuality/irekia.git"
ssh_options[:forward_agent] = true
set :keep_releases, 3

set :appserver_staging, '178.79.131.104'
set :appserver_production, '178.79.131.104'
set :user,  'ubuntu'

set(:deploy_to){
  "/home/ubuntu/www/#{application}"
}

after  "deploy:update_code", :symlinks, :set_staging_flag

desc "Restart Application"
deploy.task :restart, :roles => [:app] do
  run "touch #{current_path}/tmp/restart.txt"
end

task :symlinks, :roles => [:app] do
  run <<-CMD
    ln -s #{shared_path}/system #{release_path}/public/system;
    ln -s #{shared_path}/pdfs #{release_path}/public/;
    ln -s #{shared_path}/cache #{release_path}/public/;
    ln -s #{shared_path}/uploads #{release_path}/public/;
    rm -f #{release_path}/config/database.yml;
    rm -f #{release_path}/config/app_config.yml;
    ln -s #{shared_path}/config/database.yml #{release_path}/config/database.yml;
    ln -s #{shared_path}/config/app_config.yml #{release_path}/config/app_config.yml;
  CMD
end

desc "Uploads config yml files to app server's shared config folder"
task :upload_yml_files, :roles => :app do
  run "mkdir #{deploy_to}/shared/config ; true"
  upload("config/database.#{stage}.yml", "#{deploy_to}/shared/config/database.yml")
  upload("config/app_config.#{stage}.yml", "#{deploy_to}/shared/config/app_config.yml")
end

desc "Setup the entire project in the current environment"
task :setup, :roles => :app do
  run "cd #{current_release} && RAILS_ENV=#{stage} bundle exec rake setup"
end

namespace :db do
  desc "Run rake:seed on remote app server"
  task :seed, :roles => :app do
    run "cd #{current_release} && RAILS_ENV=#{stage} bundle exec rake db:seed"
  end

  desc "Setup the database"
  task :setup, :roles => :app do
    run "cd #{current_release} && RAILS_ENV=#{stage} bundle exec rake db:setup"
  end

  desc "Resets the database"
  task :reset, :roles => :app do
    run "cd #{current_release} && RAILS_ENV=#{stage} bundle exec rake db:reset"
  end
end

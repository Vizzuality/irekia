#!/usr/bin/env ruby

require 'fileutils'

rsync_cmd = 'rsync -vrlptz --progress --human-readable --progress'

APP_DIR        = File.expand_path('../../',  __FILE__)
DEPLOYMENT_DIR = File.expand_path('../../tmp/deployments/production',  __FILE__)
HISTORY_DIR    = File.expand_path("../../tmp/deployments/history/production/#{Time.now.strftime('%Y%m%d%H%M%S')}",  __FILE__)
PRODUCTION_SERVER_USER = 'virekia'
PRODUCTION_SERVER_IP   = '212.142.249.39'
PRODUCTION_CONNECTION  = "#{PRODUCTION_SERVER_USER}@#{PRODUCTION_SERVER_IP}"
PRODUCTION_FOLDER      = '/usr/app/virekia'
PRODUCTION_RSYNC       = "#{PRODUCTION_CONNECTION}:#{PRODUCTION_FOLDER}"


puts 'Deploying Irekia to production environment'
puts '=========================================='
puts ''

puts '=> Checking-in to production branch'
system <<-CMD
  git checkout production
  git merge staging
  git push origin production
CMD

puts '=> Copying files'

FileUtils.rm_rf DEPLOYMENT_DIR
FileUtils.mkdir_p DEPLOYMENT_DIR
FileUtils.cp   File.join(APP_DIR, 'config.rb'),          DEPLOYMENT_DIR
FileUtils.cp   File.join(APP_DIR, 'config.ru'),          DEPLOYMENT_DIR
FileUtils.cp   File.join(APP_DIR, 'Gemfile.production'), DEPLOYMENT_DIR
FileUtils.cp   File.join(APP_DIR, 'Rakefile'),           DEPLOYMENT_DIR
FileUtils.cp   File.join(APP_DIR, 'README.md'),          DEPLOYMENT_DIR
FileUtils.cp_r File.join(APP_DIR, 'app'),                DEPLOYMENT_DIR
FileUtils.cp_r File.join(APP_DIR, 'config'),             DEPLOYMENT_DIR
FileUtils.cp_r File.join(APP_DIR, 'db'),                 DEPLOYMENT_DIR
FileUtils.cp_r File.join(APP_DIR, 'lib'),                DEPLOYMENT_DIR
FileUtils.cp_r File.join(APP_DIR, 'public'),             DEPLOYMENT_DIR
FileUtils.cp_r File.join(APP_DIR, 'script'),             DEPLOYMENT_DIR
FileUtils.cp_r File.join(APP_DIR, 'vendor'),             DEPLOYMENT_DIR

FileUtils.rm_rf File.join(DEPLOYMENT_DIR, 'public/uploads/image')
FileUtils.rm_rf File.join(DEPLOYMENT_DIR, 'public/uploads/tmp')

FileUtils.mv   File.join(DEPLOYMENT_DIR, 'Gemfile.production'),   File.join(DEPLOYMENT_DIR, 'Gemfile')

FileUtils.rm_f File.join(DEPLOYMENT_DIR, 'config/database.yml')
FileUtils.rm_f File.join(DEPLOYMENT_DIR, 'config/database.yml')
FileUtils.rm_f File.join(DEPLOYMENT_DIR, 'config/database.staging.yml')
FileUtils.rm_f File.join(DEPLOYMENT_DIR, 'config/app_config.yml')
FileUtils.rm_f File.join(DEPLOYMENT_DIR, 'config/app_config.staging.yml')
FileUtils.mv   File.join(DEPLOYMENT_DIR, 'config/database.production.yml'),   File.join(DEPLOYMENT_DIR, 'config/database.yml')
FileUtils.mv   File.join(DEPLOYMENT_DIR, 'config/app_config.production.yml'), File.join(DEPLOYMENT_DIR, 'config/app_config.yml')

FileUtils.rm_f File.join(DEPLOYMENT_DIR, 'config/locales/es.yml')
FileUtils.rm_f File.join(DEPLOYMENT_DIR, 'config/locales/eu.yml')
FileUtils.rm_f File.join(DEPLOYMENT_DIR, 'config/locales/en.yml')

puts '=> Updating Gemfile'

system "bundle --gemfile=#{File.join(DEPLOYMENT_DIR, 'Gemfile')}"

puts '=> Backing up current version'

FileUtils.mkdir_p "#{HISTORY_DIR}/public"

scp_commands =  <<-CMD

scp -r #{PRODUCTION_CONNECTION}:"#{PRODUCTION_FOLDER}/config.rb \
                                 #{PRODUCTION_FOLDER}/config.ru \
                                 #{PRODUCTION_FOLDER}/Rakefile  \
                                 #{PRODUCTION_FOLDER}/README.md \
                                 #{PRODUCTION_FOLDER}/app       \
                                 #{PRODUCTION_FOLDER}/config    \
                                 #{PRODUCTION_FOLDER}/db        \
                                 #{PRODUCTION_FOLDER}/lib       \
                                 #{PRODUCTION_FOLDER}/script    \
                                 #{PRODUCTION_FOLDER}/vendor" #{HISTORY_DIR}/

scp -r #{PRODUCTION_CONNECTION}:"#{PRODUCTION_FOLDER}/public/404.html    \
                                 #{PRODUCTION_FOLDER}/public/422.html    \
                                 #{PRODUCTION_FOLDER}/public/500.html    \
                                 #{PRODUCTION_FOLDER}/public/datalogger  \
                                 #{PRODUCTION_FOLDER}/public/favicon.ico \
                                 #{PRODUCTION_FOLDER}/public/fonts       \
                                 #{PRODUCTION_FOLDER}/public/images      \
                                 #{PRODUCTION_FOLDER}/public/javascripts \
                                 #{PRODUCTION_FOLDER}/public/mp3         \
                                 #{PRODUCTION_FOLDER}/public/robots.txt  \
                                 #{PRODUCTION_FOLDER}/public/scss        \
                                 #{PRODUCTION_FOLDER}/public/stylesheets \
                                 #{PRODUCTION_FOLDER}/public/swf"         #{HISTORY_DIR}/public/
CMD

system scp_commands

puts '=> Syncing production server'

system "#{rsync_cmd} #{DEPLOYMENT_DIR}/* #{PRODUCTION_RSYNC}"

puts '=> Restarting server'

system "ssh #{PRODUCTION_CONNECTION} 'cd #{PRODUCTION_FOLDER}; touch tmp/restart.txt'"

puts '=> Checking-in to master branch'

system "git checkout master"



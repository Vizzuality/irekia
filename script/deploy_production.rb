#!/usr/bin/env ruby

require 'fileutils'

puts 'Deploying Irekia to production environment'
puts '=========================================='
puts ''

system <<-CMD
  git checkout production
  git merge staging
  git push origin production
CMD

APP_DIR        = File.expand_path('../../',  __FILE__)
DEPLOYMENT_DIR = File.expand_path('../../tmp/deployments/production',  __FILE__)

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

system "bundle --gemfile=#{File.join(DEPLOYMENT_DIR, 'Gemfile')}"

PRODUCTION_SERVER_USER= 'virekia'
PRODUCTION_SERVER_IP = '212.142.249.39'
PRODUCTION_CONNECTION = "#{PRODUCTION_SERVER_USER}@#{PRODUCTION_SERVER_IP}"
PRODUCTION_FOLDER = '/usr/app/virekia'
PRODUCTION_RSYNC = "#{PRODUCTION_CONNECTION}:#{PRODUCTION_FOLDER}"

rsync_cmd = 'rsync -vrlptz --progress --human-readable --progress'

system <<-CMD
  #{rsync_cmd} #{DEPLOYMENT_DIR}/* #{PRODUCTION_RSYNC}

  ssh #{PRODUCTION_CONNECTION} 'cd #{PRODUCTION_FOLDER} && touch tmp/restart.txt'

  git checkout master
CMD

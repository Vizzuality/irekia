desc "Setup Irekia Project for first time"
task :setup => %w(irekia:setup_database irekia:validate_all_not_moderated) do
    if Rails.env.development?
      system 'rake irekia:setup_database RAILS_ENV=test'
      # ENV["RAILS_ENV"] = 'test'
      # RAILS_ENV.replace('test') if defined?(RAILS_ENV)
      # load "#{RAILS_ROOT}/config/environment.rb"

      # Rake::Task['irekia:setup_database'].reenable
      # Rake::Task['irekia:setup_database'].invoke
    end
end

namespace :irekia do
  desc "Setup Irekia Database"
  task :setup_database => %w(db:drop db:create db:migrate db:seed)

  desc "Accepts all non moderated contents/participations"
  task :validate_all_not_moderated => :environment do
    Content.validate_all_not_moderated
    Participation.validate_all_not_moderated
  end
end

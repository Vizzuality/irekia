desc "Setup Irekia Project for first time"
task :setup do
    system "rake irekia:setup_database"
    system "rake irekia:validate_all_not_moderated"
    system "rake irekia:setup_database RAILS_ENV=test" if Rails.env.development?
end

namespace :irekia do
  desc "Setup Irekia Database"
  task :setup_database => %w(db:drop db:create db:migrate db:test:prepare db:seed)

  desc "Accepts all non moderated contents/participations"
  task :validate_all_not_moderated => :environment do
    Content.validate_all_not_moderated
    Participation.validate_all_not_moderated
  end
end

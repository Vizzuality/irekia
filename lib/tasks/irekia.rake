desc "Setup Irekia Project for first time"
task :setup do
    [Rails.env, :test].each do |env|
      system "rake irekia:setup_database RAILS_ENV=#{env.to_s}"
    end
    system "rake irekia:validate_all_not_moderated"
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

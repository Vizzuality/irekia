desc "Setup Irekia Project for first time"
task :setup => %w(irekia:setup_database irekia:validate_all_not_moderated irekia:randomize_all)

namespace :irekia do
  desc "Setup Irekia Database"
  task :setup_database => %w(db:drop db:create db:migrate db:seed)

  desc "Accepts all non moderated contents/participations"
  task :validate_all_not_moderated => :environment do
    Content.validate_all_not_moderated
    Participation.validate_all_not_moderated
  end

  desc "Randomizes publishing dates in all contents/participations"
  task :randomize_all => :environment do
    Content.find_each do |content|
      content.published_at =  Time.current.advance(:days => -rand(5), :hours => -rand(24), :minutes => -rand(60))
      content.save!
    end
    Participation.find_each do |participation|
      participation.published_at =  Time.current.advance(:days => -rand(5), :hours => -rand(24), :minutes => -rand(60))
      participation.save!
    end
  end
end

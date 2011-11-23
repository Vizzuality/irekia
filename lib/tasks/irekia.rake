desc "Setup Irekia Project for first time"
task :setup => %w(irekia:setup_database irekia:validate_all_not_moderated irekia:randomize_all)

namespace :irekia do
  desc "Setup Irekia Database"
  task :setup_database => %w(irekia:drop_tables db:migrate db:seed)

  desc "Empties all irekia tables"
  task :drop_tables => :environment do
    tables = %w(answer_data answer_opinion_data area_public_streams areas areas_contents areas_users argument_data comment_data contents contents_users event_data follows images news_data notifications participations proposal_data question_data roles schema_migrations status_message_data titles tweet_data user_private_streams user_public_streams users vote_data)
    tables.each{|table_name| ActiveRecord::Base.connection.execute("DROP TABLE #{table_name};")}
  end

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

  desc "Loads news from the official Irekia news feed"
  task :load_news => :environment do
    Irekia::Importer.get_news_from_rss
  end
end

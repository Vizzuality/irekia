desc "Setup Irekia Project for first time"
task :setup => %w(irekia:setup_database irekia:import_areas_and_politicians irekia:load_test_data irekia:import_news_and_events irekia:import_users)

namespace :irekia do
  desc "Setup Irekia Database"
  task :setup_database => %w(irekia:drop_tables db:migrate db:seed)

  desc "Empties all irekia tables"
  task :drop_tables => :environment do
    tables = %w(answer_data area_public_streams areas areas_contents areas_users argument_data comment_data contents contents_users event_data follows images news_data notifications participations proposal_data question_data roles schema_migrations status_message_data titles tweet_data user_private_streams user_public_streams users vote_data video_data attachments)
    tables.each do |table_name|
      begin
        ActiveRecord::Base.connection.execute("DROP TABLE #{table_name};")
      rescue Exception => ex
        puts ex
      end
    end
  end

  desc "Loads fake data for testing purposes"
  task :load_test_data => :environment do
    load Rails.root.join('db/seeds/seeds.rb') unless Rails.env.production?
  end

  desc "Loads news from the official Irekia news feed"
  task :import_news_and_events => :environment do
    begin
      Irekia::Importer.get_news_from_rss
      Irekia::Importer.get_events_from_ics
    ensure
      ActiveRecord::Base.connection.execute 'VACUUM;'
    end
  end

  desc "Loads areas and politicians from the official Irekia communication guide"
  task :import_areas_and_politicians => :environment do
    Irekia::Importer.get_areas_and_politicians
  end

  desc "Loads users from old irekia"
  task :import_users => :environment do
    Irekia::Importer.import_users# if Rails.env.production?
  end

  desc "Loads old proposals from a data file"
  task :import_proposals => :environment do
    Irekia::Importer.import_proposals
  end

  task :update_areas_and_politicians => :environment do
    Irekia::Importer.update_areas_and_politicians_descriptions
  end
end

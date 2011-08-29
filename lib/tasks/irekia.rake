namespace :irekia do
  desc "Setup Irekia Database"
  task :setup_database => %w(db:drop:all db:create db:migrate db:test:prepare) do
    [:development, :test].each do |env|

      puts "Loading seed data for #{env} environment:"
      puts '*****************************************'
      begin
        ActiveRecord::Base.establish_connection(env.to_s)
        Rake::Task['db:seed'].reenable
        Rake::Task['db:seed'].execute
        ActiveRecord::Base.establish_connection(ENV['RAILS_ENV'])
      rescue Exception => e
        puts e
      end

      puts ''
    end
  end

  desc "Accepts all non moderated contents/participations"
  task :validate_all_not_moderated => :environment do
    Content.validate_all_not_moderated
    Participation.validate_all_not_moderated
  end
end
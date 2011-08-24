namespace :irekia do
  desc "Setup Irekia Database"
  task :setup_database => %w(db:drop:all db:create db:migrate db:test:prepare) do
    [:development, :test].each do |env|

      puts "Loading seed data for #{env} environment:"
      puts '*****************************************'

      ActiveRecord::Base.establish_connection(env.to_s)
      Rake::Task['db:seed'].reenable
      Rake::Task['db:seed'].execute
      ActiveRecord::Base.establish_connection(ENV['RAILS_ENV'])

      puts ''
    end
  end
end
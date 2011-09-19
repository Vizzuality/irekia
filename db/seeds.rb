#encoding: UTF-8

%w(master_tables).each do |seed|
  puts '- Loading seed data:'.red
  load Rails.root.join('db', 'seeds', "#{seed}.rb")
end

if Rails.env.development? || Rails.env.test? || Rails.env.staging?
  puts ''
  puts '- Loading test data'.red

  Delorean.time_travel_to '08/03/2011' if Rails.env.test?

  load Rails.root.join('db', 'seeds', 'test_data', 'test_data.rb')

  Delorean.back_to_the_present if Rails.env.test?

  puts ''
end

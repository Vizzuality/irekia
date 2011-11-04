#encoding: UTF-8

%w(master_tables).each do |seed|
  puts '- Loading seed data:'.red
  load Rails.root.join('db', 'seeds', "#{seed}.rb")
end

puts "Loading seed data".red

load Rails.root.join('db/seeds/seeds.rb')

#encoding: UTF-8

puts '- Loading seed data:'.red
puts ''
%w(roles titles areas).each do |seed|
  load Rails.root.join('db/seeds', "#{seed}.rb")
end

unless Rails.env.production?
  puts ''
  puts "- Loading testing data".red

  load Rails.root.join('db/seeds/seeds.rb')
end

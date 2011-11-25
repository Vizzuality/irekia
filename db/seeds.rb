#encoding: UTF-8

puts '- Loading seed data:'
puts ''
%w(roles titles areas).each do |seed|
  load Rails.root.join('db/seeds', "#{seed}.rb")
end

puts ''
puts "- Loading testing data"

load Rails.root.join('db/seeds/seeds.rb')

puts ''

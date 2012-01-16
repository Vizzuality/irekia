#encoding: UTF-8

puts '- Loading seed data:'
puts ''
%w(roles titles areas users).each do |seed|
  load Rails.root.join('db/seeds', "#{seed}.rb")
end
